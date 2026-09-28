import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  EmergencyScreen({super.key});

  final List<Map<String, String>> emergencyContacts = [
    {
      'name': 'National Emergency',
      'number': '112',
      'description': 'Police, Fire and Medical Emergency',
    },
    {
      'name': 'Police',
      'number': '100',
      'description': 'For police emergencies',
    },
    {'name': 'Fire', 'number': '101', 'description': 'For fire emergencies'},
    {
      'name': 'Ambulance',
      'number': '108',
      'description': 'For medical emergencies',
    },
  ];

  Future<void> _makeCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        title: const Text(
          'Emergency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.emergency,
                    color: Colors.red.shade700,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Call the appropriate emergency service when needed.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          ...emergencyContacts.map((contact) {
            return _contactCard(
              name: contact['name']!,
              number: contact['number']!,
              description: contact['description']!,
            );
          }),
        ],
      ),
    );
  }

  Widget _contactCard({
    required String name,
    required String number,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

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
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(Icons.phone, color: Colors.red.shade700),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 5),

                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () => _makeCall(number),

            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),

            icon: const Icon(Icons.call),
          ),
        ],
      ),
    );
  }
}
