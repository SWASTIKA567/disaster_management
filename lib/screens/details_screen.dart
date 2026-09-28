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

            const SizedBox(height: 24),

            // Safety Tips Section
            _SafetyTipsSection(eventType: disaster.eventType),

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

// ─── Safety Tips Section ────────────────────────────────────────────────────

class _SafetyTipsSection extends StatelessWidget {
  final String eventType;

  const _SafetyTipsSection({required this.eventType});

  /// Returns a list of tip maps: {phase, icon, color, tip}
  List<Map<String, dynamic>> _getTips() {
    switch (eventType.toUpperCase()) {
      case 'TC': // Cyclone
        return [
          {'phase': 'Before', 'icon': Icons.home_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Secure windows, doors and loose outdoor items.'},
          {'phase': 'Before', 'icon': Icons.battery_charging_full_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Stock up on food, water, medicines and torch batteries.'},
          {'phase': 'Before', 'icon': Icons.people_alt_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Know your nearest evacuation shelter and plan your route.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Stay indoors, away from windows and glass doors.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Do NOT go outside during the eye of the storm — it will resume.'},
          {'phase': 'During', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Listen to emergency broadcasts on a battery-powered radio.'},
          {'phase': 'After', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Beware of downed power lines and flooded roads.'},
          {'phase': 'After', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Use only bottled or boiled water — tap supply may be contaminated.'},
        ];

      case 'EQ': // Earthquake
        return [
          {'phase': 'Before', 'icon': Icons.inventory_2_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Prepare an emergency kit with water, food and first aid.'},
          {'phase': 'Before', 'icon': Icons.chair_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Secure heavy furniture and appliances to walls.'},
          {'phase': 'During', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Drop, Cover and Hold On — get under a sturdy table.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Do NOT run outside — most injuries occur near doorways or exits.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Stay away from windows, shelves and heavy objects.'},
          {'phase': 'After', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Check for gas leaks — if you smell gas, open windows and evacuate.'},
          {'phase': 'After', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Expect aftershocks. Stay away from damaged buildings.'},
          {'phase': 'After', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Do NOT use elevators after a quake.'},
        ];

      case 'FL': // Flood
        return [
          {'phase': 'Before', 'icon': Icons.move_up_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Move valuables and electronics to higher floors.'},
          {'phase': 'Before', 'icon': Icons.directions_car_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Move your vehicle to higher ground immediately.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Never walk or drive through floodwater — 15 cm can knock you down.'},
          {'phase': 'During', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Climb to the highest point in your building if trapped.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Avoid contact with floodwater — it may carry sewage or chemicals.'},
          {'phase': 'After', 'icon': Icons.cleaning_services_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Disinfect all surfaces that contacted floodwater.'},
          {'phase': 'After', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Do not use tap water until authorities declare it safe.'},
          {'phase': 'After', 'icon': Icons.electric_bolt_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Do not turn on electricity if the building was flooded.'},
        ];

      case 'WF': // Wildfire
        return [
          {'phase': 'Before', 'icon': Icons.grass_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Clear dry leaves and debris within 10 m of your home.'},
          {'phase': 'Before', 'icon': Icons.directions_run_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Know your evacuation route and leave early if ordered.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Do NOT delay evacuation — wildfires can spread in minutes.'},
          {'phase': 'During', 'icon': Icons.masks_rounded, 'color': const Color(0xFF10B981), 'tip': 'Cover your nose and mouth with a wet cloth to reduce smoke inhalation.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Avoid valleys, canyons and natural chimneys — fire spreads uphill fast.'},
          {'phase': 'After', 'icon': Icons.home_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Do not return until authorities declare the area safe.'},
          {'phase': 'After', 'icon': Icons.masks_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Wear an N95 mask when returning — ash and soot are hazardous.'},
        ];

      case 'VO': // Volcano
        return [
          {'phase': 'Before', 'icon': Icons.masks_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Prepare N95 masks and goggles for ash protection.'},
          {'phase': 'Before', 'icon': Icons.directions_run_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Know the exclusion zones and evacuation routes.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Evacuate immediately if authorities issue an eruption warning.'},
          {'phase': 'During', 'icon': Icons.home_rounded, 'color': const Color(0xFF10B981), 'tip': 'If indoors, seal doors, windows and vents against ash fall.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Stay away from river valleys — lahars (mud flows) travel fast.'},
          {'phase': 'After', 'icon': Icons.roofing_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Clear ash from rooftops — wet ash is extremely heavy and can collapse roofs.'},
          {'phase': 'After', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Do not drink tap water until tested — ash contaminates supplies.'},
        ];

      case 'TS': // Tsunami
        return [
          {'phase': 'Before', 'icon': Icons.terrain_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Know your local tsunami evacuation routes to high ground.'},
          {'phase': 'Before', 'icon': Icons.campaign_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Learn the natural warning signs — strong quake, unusual wave retreat.'},
          {'phase': 'During', 'icon': Icons.directions_run_rounded, 'color': const Color(0xFFEF4444), 'tip': 'If you feel a strong quake near the coast, move to high ground immediately. Do NOT wait for an official warning.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Never go to the shore to watch a tsunami — you will not outrun it.'},
          {'phase': 'During', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'If caught, grab something that floats and protect your head.'},
          {'phase': 'After', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Stay away from the coast until authorities give the all-clear — multiple waves hit over hours.'},
          {'phase': 'After', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Avoid floodwater — it may hide debris and strong currents.'},
        ];

      case 'DR': // Drought
        return [
          {'phase': 'Before', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Store adequate drinking water — at least 3 days of supply per person.'},
          {'phase': 'Before', 'icon': Icons.grass_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Conserve water: fix leaks, use drip irrigation for crops.'},
          {'phase': 'During', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Follow official water rationing guidelines strictly.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Avoid burning fields or open burning — drought raises wildfire risk.'},
          {'phase': 'During', 'icon': Icons.wb_sunny_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Avoid outdoor activities in peak afternoon heat — risk of heat stroke.'},
          {'phase': 'After', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Continue conserving water even when rains return — reserves take time to replenish.'},
        ];

      default: // Generic
        return [
          {'phase': 'Before', 'icon': Icons.inventory_2_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Prepare an emergency kit with water, food, torch and first aid supplies.'},
          {'phase': 'Before', 'icon': Icons.people_alt_rounded, 'color': const Color(0xFF0284C7), 'tip': 'Know your local emergency contacts and nearest shelter.'},
          {'phase': 'During', 'icon': Icons.campaign_rounded, 'color': const Color(0xFF10B981), 'tip': 'Follow instructions from local emergency authorities.'},
          {'phase': 'During', 'icon': Icons.close_rounded, 'color': const Color(0xFFEF4444), 'tip': 'Avoid unnecessary travel or outdoor activity during the event.'},
          {'phase': 'After', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFFF59E0B), 'tip': 'Check on neighbours, especially the elderly and children.'},
          {'phase': 'After', 'icon': Icons.check_rounded, 'color': const Color(0xFF10B981), 'tip': 'Report damage or hazards to local authorities promptly.'},
        ];
    }
  }

  Color get _accentColor {
    switch (eventType.toUpperCase()) {
      case 'TC': return const Color(0xFF0284C7);
      case 'EQ': return const Color(0xFF8B5CF6);
      case 'FL': return const Color(0xFF06B6D4);
      case 'WF': return const Color(0xFFEA580C);
      case 'VO': return const Color(0xFFDC2626);
      case 'TS': return const Color(0xFF0891B2);
      case 'DR': return const Color(0xFFD97706);
      default:   return const Color(0xFF475569);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = _getTips();
    final phases = ['Before', 'During', 'After'];
    final phaseColors = {
      'Before': const Color(0xFF0284C7),
      'During': const Color(0xFFEF4444),
      'After' : const Color(0xFFF59E0B),
    };
    final phaseBg = {
      'Before': const Color(0xFFEFF6FF),
      'During': const Color(0xFFFEF2F2),
      'After' : const Color(0xFFFFFBEB),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.health_and_safety_rounded, color: _accentColor, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Safety Tips & Action Guide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'What you should do before, during and after this event.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        // Per-phase groups
        ...phases.map((phase) {
          final phaseTips = tips.where((t) => t['phase'] == phase).toList();
          if (phaseTips.isEmpty) return const SizedBox.shrink();
          final color = phaseColors[phase]!;
          final bg = phaseBg[phase]!;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phase label
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        phase.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tips list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: phaseTips.asMap().entries.map((entry) {
                      final i = entry.key;
                      final t = entry.value;
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: (t['color'] as Color).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(t['icon'] as IconData, size: 16, color: t['color'] as Color),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    t['tip'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF334155),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (i < phaseTips.length - 1)
                            const Divider(height: 18, color: Color(0xFFE2E8F0)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

