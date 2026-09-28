import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/disaster_controller.dart';
import 'details_screen.dart';

class AlertsScreen extends StatelessWidget {
  AlertsScreen({super.key});

  final DisasterController controller = Get.find<DisasterController>();
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Cyclone',
    'Earthquake',
    'Flood',
    'Volcano',
    'Wildfire',
  ];

  final List<String> severities = ['All', 'Red', 'Orange', 'Green'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0F172A),
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text(
          'Live Disaster Feed',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            onPressed: controller.fetchDisasters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: searchController,
                  onChanged: controller.setSearchQuery,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by region, hazard, country...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    suffixIcon: Obx(() {
                      if (controller.searchQuery.value.isNotEmpty) {
                        return IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            searchController.clear();
                            controller.setSearchQuery('');
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: categories.map((cat) {
                      return Obx(() {
                        final isSelected =
                            controller.selectedCategory.value == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) =>
                                controller.setSelectedCategory(cat),
                            backgroundColor: const Color(0xFFF8FAFC),
                            selectedColor: const Color(0xFF0F172A),
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFE2E8F0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            showCheckmark: false,
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // Severity Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: severities.map((sev) {
                      return Obx(() {
                        final isSelected =
                            controller.selectedSeverity.value == sev;
                        Color sevColor = const Color(0xFF0F172A);
                        if (sev == 'Red') sevColor = const Color(0xFFEF4444);
                        if (sev == 'Orange') sevColor = const Color(0xFFF59E0B);
                        if (sev == 'Green') sevColor = const Color(0xFF10B981);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => controller.setSelectedSeverity(sev),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? sevColor.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? sevColor
                                      : const Color(0xFFE2E8F0),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (sev != 'All') ...[
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: sevColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    sev == 'All'
                                        ? 'All Severities'
                                        : '$sev Alert',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? sevColor
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Alert List Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0F172A),
                    strokeWidth: 2.5,
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.disasters.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: controller.fetchDisasters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final list = controller.filteredDisasters;

              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No alerts match your filter criteria',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Try clearing search keywords or selecting all categories.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            searchController.clear();
                            controller.setSearchQuery('');
                            controller.setSelectedCategory('All');
                            controller.setSelectedSeverity('All');
                          },
                          child: const Text('Reset All Filters'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF0F172A),
                onRefresh: controller.fetchDisasters,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final disaster = list[index];
                    final alertColor = disaster.alertColor;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => DetailScreen(disaster: disaster));
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Category + Severity badge + Time
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: alertColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        disaster.iconData,
                                        color: alertColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            disaster.categoryDisplayName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            disaster.displayLocation,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: disaster.alertBgColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: alertColor.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: alertColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            disaster.alertLevel,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: alertColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Title
                                Text(
                                  disaster.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Description snippet
                                Text(
                                  disaster.description.isNotEmpty
                                      ? disaster.description
                                      : 'Real-time hazard alert detected by global observation instruments.',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 12),

                                // Bottom metrics & time
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (disaster.severityText.isNotEmpty)
                                      Expanded(
                                        child: Text(
                                          disaster.severityText,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF334155),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 13,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          disaster.formattedDate,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 12,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
