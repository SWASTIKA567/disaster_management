import 'package:flutter/material.dart';

import '../models/disaster_model.dart';

class DetailScreen extends StatelessWidget {
  final DisasterModel disaster;

  const DetailScreen({super.key, required this.disaster});

  Color getAlertColor(String level) {
    switch (level.toLowerCase()) {
      case 'red':
        return Colors.red;

      case 'orange':
        return Colors.orange;

      case 'green':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertColor = getAlertColor(disaster.alertLevel);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        title: const Text(
          'Disaster Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Top disaster card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(22),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: alertColor,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          disaster.alertLevel.isEmpty
                              ? 'Unknown'
                              : disaster.alertLevel.toUpperCase(),

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    disaster.eventName.isEmpty
                        ? 'Unknown Event'
                        : disaster.eventName,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    disaster.categoryDisplayName,

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Event Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // Country
            _infoCard(
              icon: Icons.location_on_outlined,
              title: 'Country',
              value: disaster.country.isEmpty
                  ? 'Not available'
                  : disaster.country,
            ),

            // Disaster type
            _infoCard(
              icon: Icons.category_outlined,
              title: 'Disaster Type',
              value: disaster.categoryDisplayName,
            ),

            // Start date
            _infoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Start Date',
              value: disaster.date.isEmpty ? 'Not available' : disaster.date,
            ),

            // End date
            _infoCard(
              icon: Icons.event_outlined,
              title: 'End Date',
              value: disaster.toDate.isEmpty
                  ? 'Not available'
                  : disaster.toDate,
            ),

            const SizedBox(height: 15),

            // Event ID
            _infoCard(
              icon: Icons.tag,
              title: 'Event ID',
              value: disaster.eventId.isEmpty
                  ? 'Not available'
                  : disaster.eventId,
            ),

            const SizedBox(height: 20),

            // Description section
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                disaster.description.isNotEmpty
                    ? disaster.description
                    : disaster.htmlDescription.isNotEmpty
                        ? disaster.htmlDescription
                        : 'No description available for this event.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
            ),

            // Severity section (if available)
            if (disaster.severityText.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Severity Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _infoCard(
                icon: Icons.bar_chart_rounded,
                title: 'Severity',
                value: disaster.severityText,
              ),
            ],

            const SizedBox(height: 20),

            // Information note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'This disaster information is retrieved '
                      'from GDACS and represents a live disaster event.',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.blue.shade700),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
