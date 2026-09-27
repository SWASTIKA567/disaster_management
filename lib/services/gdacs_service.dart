import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/disaster_model.dart';

class GdacsService {
  static const String baseUrl =
      'https://www.gdacs.org/gdacsapi/api/Events/geteventlist/events4app';

  Future<List<DisasterModel>> fetchDisasters() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> events = data['features'] ?? [];

      return events
          .map((event) => DisasterModel.fromJson(event['properties'] ?? {}))
          .toList();
    } else {
      throw Exception('Failed to load disaster data');
    }
  }
}
