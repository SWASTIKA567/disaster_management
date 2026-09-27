import 'package:get/get.dart';

import '../models/disaster_model.dart';
import '../services/gdacs_service.dart';

class DisasterController extends GetxController {
  final GdacsService _gdacsService = GdacsService();

  // Stores all disasters received from GDACS
  final RxList<DisasterModel> disasters = <DisasterModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisasters();
  }

  Future<void> fetchDisasters() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _gdacsService.fetchDisasters();

      disasters.value = result;
    } catch (e) {
      errorMessage.value = 'Failed to load disaster alerts';
    } finally {
      isLoading.value = false;
    }
  }
}
