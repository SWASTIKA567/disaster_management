import 'package:flutter/material.dart';

class DisasterModel {
  final String eventId;
  final String eventType;
  final String eventName;
  final String name;
  final String country;
  final String alertLevel;
  final double alertScore;
  final String description;
  final String htmlDescription;
  final String date;
  final String toDate;
  final String severityText;
  final String reportUrl;
  final double latitude;
  final double longitude;

  DisasterModel({
    required this.eventId,
    required this.eventType,
    required this.eventName,
    required this.name,
    required this.country,
    required this.alertLevel,
    required this.alertScore,
    required this.description,
    required this.htmlDescription,
    required this.date,
    required this.toDate,
    required this.severityText,
    required this.reportUrl,
    required this.latitude,
    required this.longitude,
  });

  factory DisasterModel.fromJson(Map<String, dynamic> json, {List<dynamic>? coordinates}) {
    double lat = 0.0;
    double lon = 0.0;
    if (coordinates != null && coordinates.length >= 2) {
      lon = (coordinates[0] is num) ? (coordinates[0] as num).toDouble() : 0.0;
      lat = (coordinates[1] is num) ? (coordinates[1] as num).toDouble() : 0.0;
    }

    final severityData = json['severitydata'] is Map ? json['severitydata'] : null;
    final urlData = json['url'] is Map ? json['url'] : null;

    final rawScore = json['alertscore'] ?? json['episodealertscore'] ?? 0;
    double score = 0.0;
    if (rawScore is num) {
      score = rawScore.toDouble();
    } else if (rawScore is String) {
      score = double.tryParse(rawScore) ?? 0.0;
    }

    return DisasterModel(
      eventId: json['eventid']?.toString() ?? '',
      eventType: (json['eventtype']?.toString() ?? 'OTHER').toUpperCase(),
      eventName: json['eventname']?.toString() ?? '',
      name: json['name']?.toString() ?? json['eventname']?.toString() ?? 'Incident',
      country: json['country']?.toString().trim() ?? '',
      alertLevel: json['alertlevel']?.toString().trim() ?? 'Green',
      alertScore: score,
      description: json['description']?.toString() ?? '',
      htmlDescription: json['htmldescription']?.toString() ?? '',
      date: json['fromdate']?.toString() ?? '',
      toDate: json['todate']?.toString() ?? '',
      severityText: severityData?['severitytext']?.toString() ?? '',
      reportUrl: urlData?['report']?.toString() ?? urlData?['details']?.toString() ?? '',
      latitude: lat,
      longitude: lon,
    );
  }

  String get categoryDisplayName {
    switch (eventType) {
      case 'TC':
        return 'Cyclone';
      case 'EQ':
        return 'Earthquake';
      case 'FL':
        return 'Flood';
      case 'VO':
        return 'Volcano';
      case 'WF':
        return 'Wildfire';
      case 'DR':
        return 'Drought';
      case 'TS':
        return 'Tsunami';
      default:
        return eventType.isNotEmpty ? eventType : 'Hazard';
    }
  }

  IconData get iconData {
    switch (eventType) {
      case 'TC':
        return Icons.cyclone_rounded;
      case 'EQ':
        return Icons.waves_rounded;
      case 'FL':
        return Icons.water_rounded;
      case 'VO':
        return Icons.volcano_rounded;
      case 'WF':
        return Icons.local_fire_department_rounded;
      case 'DR':
        return Icons.wb_sunny_rounded;
      case 'TS':
        return Icons.tsunami_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color get alertColor {
    final level = alertLevel.toLowerCase();
    if (level.contains('red')) {
      return const Color(0xFFEF4444); // Crimson
    } else if (level.contains('orange')) {
      return const Color(0xFFF59E0B); // Amber
    } else if (level.contains('green')) {
      return const Color(0xFF10B981); // Emerald
    }
    return const Color(0xFF64748B); // Slate
  }

  Color get alertBgColor {
    final level = alertLevel.toLowerCase();
    if (level.contains('red')) {
      return const Color(0xFFFEF2F2);
    } else if (level.contains('orange')) {
      return const Color(0xFFFFFBEB);
    } else if (level.contains('green')) {
      return const Color(0xFFECFDF5);
    }
    return const Color(0xFFF1F5F9);
  }

  String get displayLocation {
    if (country.isNotEmpty) return country;
    return 'Off-shore / International';
  }

  String get formattedDate {
    if (date.isEmpty) return 'Recent';
    try {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        final now = DateTime.now();
        final diff = now.difference(parsed);
        if (diff.inDays == 0) {
          if (diff.inHours == 0) {
            return '${diff.inMinutes.abs()}m ago';
          }
          return '${diff.inHours.abs()}h ago';
        } else if (diff.inDays < 7) {
          return '${diff.inDays.abs()}d ago';
        }
        return '${parsed.day}/${parsed.month}/${parsed.year}';
      }
    } catch (_) {}
    return date.split('T').first;
  }
}
