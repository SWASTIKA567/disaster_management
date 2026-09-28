import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/disaster_controller.dart';
import '../models/disaster_model.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  HomeScreen({super.key, this.onNavigateToTab});

  final DisasterController controller = Get.find<DisasterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'DISASTER MONITOR',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Global GDACS Surveillance Feed',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            onPressed: controller.fetchDisasters,
            tooltip: 'Refresh Feed',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.disasters.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0F172A),
              strokeWidth: 2.5,
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF0F172A),
          onRefresh: controller.fetchDisasters,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick SOS Action Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emergency_rounded,
                          color: Color(0xFFEF4444),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Response',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Speed dial hotlines & survival guides',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (onNavigateToTab != null) {
                            onNavigateToTab!(3);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('SOS Help'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Statistics Grid
                const Text(
                  'Global Situational Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total Incidents',
                        count: '${controller.totalCount}',
                        icon: Icons.public_rounded,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        label: 'Critical Red',
                        count: '${controller.redAlertCount}',
                        icon: Icons.warning_rounded,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        label: 'Moderate',
                        count: '${controller.orangeAlertCount}',
                        icon: Icons.priority_high_rounded,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Featured Alert (if any)
                if (controller.featuredAlert != null) ...[
                  const Text(
                    'High Priority Alert',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _FeaturedCrisisCard(
                    disaster: controller.featuredAlert!,
                    onTap: () {
                      Get.to(
                        () => DetailScreen(disaster: controller.featuredAlert!),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // Category Quick Filter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hazard Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (onNavigateToTab != null) {
                          controller.setSelectedCategory('All');
                          onNavigateToTab!(1);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _CategoryCard(
                        title: 'Cyclones',
                        icon: Icons.cyclone_rounded,
                        color: const Color(0xFF0284C7),
                        onTap: () {
                          controller.setSelectedCategory('Cyclone');
                          onNavigateToTab?.call(1);
                        },
                      ),
                      _CategoryCard(
                        title: 'Earthquakes',
                        icon: Icons.waves_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () {
                          controller.setSelectedCategory('Earthquake');
                          onNavigateToTab?.call(1);
                        },
                      ),
                      _CategoryCard(
                        title: 'Floods',
                        icon: Icons.water_rounded,
                        color: const Color(0xFF06B6D4),
                        onTap: () {
                          controller.setSelectedCategory('Flood');
                          onNavigateToTab?.call(1);
                        },
                      ),
                      _CategoryCard(
                        title: 'Wildfires',
                        icon: Icons.local_fire_department_rounded,
                        color: const Color(0xFFEA580C),
                        onTap: () {
                          controller.setSelectedCategory('Wildfire');
                          onNavigateToTab?.call(1);
                        },
                      ),
                      _CategoryCard(
                        title: 'Volcanoes',
                        icon: Icons.volcano_rounded,
                        color: const Color(0xFFDC2626),
                        onTap: () {
                          controller.setSelectedCategory('Volcano');
                          onNavigateToTab?.call(1);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Latest Active Alerts Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Real-Time Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateToTab?.call(1),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Explore Feed',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (controller.disasters.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: Text(
                        'No disaster events recorded right now.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                ...controller.disasters.take(5).map((disaster) {
                  final alertColor = disaster.alertColor;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
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
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: alertColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  disaster.iconData,
                                  color: alertColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          disaster.categoryDisplayName,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF94A3B8),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          disaster.formattedDate,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      disaster.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      disaster.displayLocation,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: disaster.alertBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: alertColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  disaster.alertLevel,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: alertColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FeaturedCrisisCard extends StatelessWidget {
  final DisasterModel disaster;
  final VoidCallback onTap;

  const _FeaturedCrisisCard({required this.disaster, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final alertColor = disaster.alertColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: alertColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: disaster.alertBgColor,
                        borderRadius: BorderRadius.circular(20),
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
                            '${disaster.alertLevel.toUpperCase()} ALERT PRIORITY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: alertColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      disaster.formattedDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  disaster.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  disaster.displayLocation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (disaster.severityText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    disaster.severityText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Action Guidelines',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: alertColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: alertColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
