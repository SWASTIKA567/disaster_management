import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/disaster_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DisasterController controller = Get.put(DisasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Management'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDisasters,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Live Disaster Alerts',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Latest disaster events from GDACS',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              if (controller.disasters.isEmpty)
                const Center(child: Text('No disaster events found')),

              ...controller.disasters.take(5).map((disaster) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                    ),
                    title: Text(
                      disaster.eventName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${disaster.country}\n'
                      'Alert: ${disaster.alertLevel}',
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
