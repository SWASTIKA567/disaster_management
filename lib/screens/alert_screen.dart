import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/disaster_controller.dart';

class AlertsScreen extends StatelessWidget {
  AlertsScreen({super.key});

  final DisasterController controller = Get.find<DisasterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster Alerts'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50),
                const SizedBox(height: 12),
                Text(controller.errorMessage.value),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchDisasters,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.disasters.isEmpty) {
          return const Center(child: Text('No disaster alerts available'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDisasters,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.disasters.length,
            itemBuilder: (context, index) {
              final disaster = controller.disasters[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.warning_amber_rounded),
                  ),
                  title: Text(
                    disaster.eventName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${disaster.country}\n'
                      'Type: ${disaster.eventType}\n'
                      'Alert Level: ${disaster.alertLevel}',
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
