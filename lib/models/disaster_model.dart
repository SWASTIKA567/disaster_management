class DisasterModel {
  final String eventId;
  final String eventType;
  final String eventName;
  final String country;
  final String alertLevel;
  final String description;
  final String date;

  DisasterModel({
    required this.eventId,
    required this.eventType,
    required this.eventName,
    required this.country,
    required this.alertLevel,
    required this.description,
    required this.date,
  });

  factory DisasterModel.fromJson(Map<String, dynamic> json) {
    return DisasterModel(
      eventId: json['eventid']?.toString() ?? '',
      eventType: json['eventtype']?.toString() ?? '',
      eventName: json['eventname']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      alertLevel: json['alertlevel']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: json['fromdate']?.toString() ?? '',
    );
  }
}
