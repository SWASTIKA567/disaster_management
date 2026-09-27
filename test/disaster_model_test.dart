import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_project/models/disaster_model.dart';

void main() {
  group('DisasterModel Unit Tests', () {
    test('Parses from GDACS json correctly', () {
      final json = {
        'eventtype': 'TC',
        'eventid': 1001321,
        'eventname': 'NOLO-26',
        'name': 'Tropical Cyclone NOLO-26',
        'country': 'United States',
        'alertlevel': 'Red',
        'alertscore': 2.5,
        'description': 'Severe Tropical Cyclone NOLO-26 with peak sustained winds',
        'htmldescription': 'Red Tropical Cyclone alert',
        'fromdate': '2026-09-13T21:00:00',
        'todate': '2026-09-27T09:00:00',
        'severitydata': {
          'severitytext': 'Hurricane/Typhoon > 74 mph (maximum wind speed of 215 km/h)',
        },
        'url': {
          'report': 'https://www.gdacs.org/report.aspx?eventid=1001321',
        },
      };

      final coords = [-157.3, 16.5];

      final model = DisasterModel.fromJson(json, coordinates: coords);

      expect(model.eventId, '1001321');
      expect(model.eventType, 'TC');
      expect(model.categoryDisplayName, 'Cyclone');
      expect(model.country, 'United States');
      expect(model.alertLevel, 'Red');
      expect(model.alertScore, 2.5);
      expect(model.latitude, 16.5);
      expect(model.longitude, -157.3);
      expect(model.reportUrl, 'https://www.gdacs.org/report.aspx?eventid=1001321');
    });

    test('Falls back gracefully for empty values', () {
      final model = DisasterModel.fromJson({});

      expect(model.eventId, '');
      expect(model.eventType, 'OTHER');
      expect(model.categoryDisplayName, 'OTHER');
      expect(model.displayLocation, 'Off-shore / International');
      expect(model.alertLevel, 'Green');
    });
  });
}
