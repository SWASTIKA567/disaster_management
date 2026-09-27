import 'package:get/get.dart';
import '../models/disaster_model.dart';
import '../services/gdacs_service.dart';

class DisasterController extends GetxController {
  final GdacsService _gdacsService = GdacsService();

  final RxList<DisasterModel> disasters = <DisasterModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSeverity = 'All'.obs;

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

  void setSearchQuery(String query) {
    searchQuery.value = query.trim().toLowerCase();
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSelectedSeverity(String severity) {
    selectedSeverity.value = severity;
  }

  List<DisasterModel> get filteredDisasters {
    return disasters.where((item) {
      // Category filter
      if (selectedCategory.value != 'All') {
        if (!item.categoryDisplayName
            .toLowerCase()
            .contains(selectedCategory.value.toLowerCase())) {
          return false;
        }
      }

      // Severity filter
      if (selectedSeverity.value != 'All') {
        if (item.alertLevel.toLowerCase() !=
            selectedSeverity.value.toLowerCase()) {
          return false;
        }
      }

      // Search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value;
        final matchName = item.name.toLowerCase().contains(query);
        final matchEventName = item.eventName.toLowerCase().contains(query);
        final matchCountry = item.country.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchType = item.categoryDisplayName.toLowerCase().contains(query);

        if (!matchName &&
            !matchEventName &&
            !matchCountry &&
            !matchDesc &&
            !matchType) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  DisasterModel? get featuredAlert {
    if (disasters.isEmpty) return null;
    try {
      return disasters.firstWhere(
        (d) => d.alertLevel.toLowerCase() == 'red',
        orElse: () => disasters.firstWhere(
          (d) => d.alertLevel.toLowerCase() == 'orange',
          orElse: () => disasters.first,
        ),
      );
    } catch (_) {
      return disasters.firstOrNull;
    }
  }

  int get totalCount => disasters.length;

  int get redAlertCount =>
      disasters.where((d) => d.alertLevel.toLowerCase() == 'red').length;

  int get orangeAlertCount =>
      disasters.where((d) => d.alertLevel.toLowerCase() == 'orange').length;

  int get greenAlertCount =>
      disasters.where((d) => d.alertLevel.toLowerCase() == 'green').length;
}
