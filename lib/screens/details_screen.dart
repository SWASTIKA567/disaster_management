import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/disaster_model.dart';
import 'emergency_screen.dart';

class DisasterDetailScreen extends StatelessWidget {
  final DisasterModel disaster;

  const DisasterDetailScreen({super.key, required this.disaster});

  Future<void> _openReport(BuildContext context) async {
    if (disaster.reportUrl.isEmpty) {
      Get.snackbar(
        'Notice',
        'Official report URL is not available for this incident.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
      );
      return;
    }

    final uri = Uri.parse(disaster.reportUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open the report link: ${disaster.reportUrl}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<String> _getSafetyTips() {
    switch (disaster.eventType) {
      case 'TC':
        return [
          'Stay indoors and keep away from windows, skylights, and glass doors.',
          'Shut off main electrical breaker and gas valves if instructed.',
          'Keep mobile phones and emergency power banks fully charged.',
          'Prepare a waterproof emergency go-bag with essential documents.',
          'Avoid low-lying coastal areas susceptible to destructive storm surges.',
        ];
      case 'EQ':
        return [
          'DROP, COVER, and HOLD ON under sturdy furniture until shaking stops.',
          'Stay clear of exterior walls, overhead fixtures, and large glass windows.',
          'If outside, move away from electrical poles, brick chimneys, and trees.',
          'Do not use elevators during or immediately after the tremor.',
          'Be prepared for moderate to severe secondary aftershocks.',
        ];
      case 'FL':
        return [
          'Move immediately to elevated grounds or high floors.',
          'Turn Around, Don’t Drown: never walk or drive through flowing water.',
          'Disconnect electrical appliances; do not touch wet power outlets.',
          'Drink only sealed bottled water or thoroughly boiled water.',
          'Avoid contact with contaminated water and stay clear of downed wires.',
        ];
      case 'WF':
        return [
          'Seal all windows, vents, and doors to keep smoke from entering.',
          'Wear an N95 or respirator mask if moving through smoky zones.',
          'Clear flammable debris, dry shrubs, and firewood around your shelter.',
          'Monitor evacuation alerts and evacuate immediately when instructed.',
          'Keep your vehicle packed with essentials and facing outward in driveway.',
        ];
      case 'VO':
        return [
          'Stay clear of downwind ash plume paths and active valleys.',
          'Protect eyes with goggles and mouth with a damp cloth or mask.',
          'Avoid driving in heavy ashfall as ash clogs engines and halts steering.',
          'Keep gutters and roofs cleared of heavy ash accumulation.',
        ];
      default:
        return [
          'Monitor real-time official bulletins and emergency alerts.',
          'Keep an emergency survival kit with 3 days of non-perishable food and water.',
          'Establish a family rendezvous point and communication plan.',
          'Follow instructions issued by local civil defense and disaster response authorities.',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertColor = disaster.alertColor;
    final safetyTips = _getSafetyTips();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          disaster.categoryDisplayName,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency_share_outlined, color: Color(0xFF0F172A)),
            onPressed: () {
              Get.snackbar(
                'Incident Details',
                '${disaster.name} - Alert: ${disaster.alertLevel} (${disaster.country})',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF0F172A),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Incident Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(disaster.iconData, size: 16, color: const Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              disaster.categoryDisplayName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: disaster.alertBgColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: alertColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: alertColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${disaster.alertLevel.toUpperCase()} ALERT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: alertColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Title
                  Text(
                    disaster.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location and Timestamp Row
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          disaster.displayLocation,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        disaster.formattedDate,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Key Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Alert Score',
                    value: disaster.alertScore > 0
                        ? disaster.alertScore.toStringAsFixed(1)
                        : disaster.alertLevel,
                    icon: Icons.speed_rounded,
                    accentColor: alertColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Status',
                    value: 'Active Live',
                    icon: Icons.radar_rounded,
                    accentColor: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Latitude',
                    value: disaster.latitude != 0.0
                        ? '${disaster.latitude.toStringAsFixed(2)}°'
                        : 'Recorded',
                    icon: Icons.explore_outlined,
                    accentColor: const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Longitude',
                    value: disaster.longitude != 0.0
                        ? '${disaster.longitude.toStringAsFixed(2)}°'
                        : 'Recorded',
                    icon: Icons.language_rounded,
                    accentColor: const Color(0xFF0D9488),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Incident Description Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF0284C7)),
                      SizedBox(width: 8),
                      Text(
                        'Incident Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    disaster.description.isNotEmpty
                        ? disaster.description
                        : 'No detailed situational summary provided by the monitoring network.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF334155),
                    ),
                  ),
                  if (disaster.severityText.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insights_rounded, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              disaster.severityText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Safety & Action Guidelines
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 20, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Text(
                        'Safety Guidelines for ${disaster.categoryDisplayName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...safetyTips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF334155),
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openReport(context),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Official Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const EmergencyScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.phone_in_talk_rounded, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'SOS',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
