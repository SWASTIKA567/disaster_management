import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final Map<String, bool> _emergencyKitItems = {
    'Water (1 Gallon / 4 Litres per person)': false,
    'Non-perishable food / Protein bars (3 days)': false,
    'First Aid Kit & Essential Medications': false,
    'High-power Flashlight & Extra Batteries': false,
    'Signal Whistle (to alert search teams)': false,
    'Portable Power Bank & Charging Cable': false,
    'Waterproof Pouch with National ID & Insurance': false,
    'Multi-tool / Swiss Knife': false,
  };

  Future<void> _makeCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        'Call Notice',
        'Could not initiate dialer for $phoneNumber.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
      );
    }
  }

  void _sendDistressNotice() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Distress Beacon Message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sample broadcast text to send to family or rescue authorities:',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                'EMERGENCY: I am affected by a disaster incident. Current Status: Needs assistance. Please check my last known coordinates.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Copied',
                    'Distress beacon text copied to clipboard.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF0F172A),
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy Distress Text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text(
          'Emergency SOS',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prominent SOS Call Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'IMMEDIATE ASSISTANCE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.emergency_rounded, color: Colors.white70, size: 28),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Need Urgent Help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'One-tap direct dial to national emergency response services. Works even without mobile data.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeCall('112'),
                          icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                          label: const Text('Dial 112 (Universal)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFDC2626),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: _sendDistressNotice,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.share_location_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Hotline Directory Section
            const Text(
              'Emergency Hotlines',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap any service card to dial immediately',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),

            _HotlineCard(
              title: 'Disaster Management Helpline',
              subtitle: 'NDRF / Civil Defense / National Incident Command',
              number: '1078',
              icon: Icons.shield_rounded,
              color: const Color(0xFF0284C7),
              onTap: () => _makeCall('1078'),
            ),
            const SizedBox(height: 10),
            _HotlineCard(
              title: 'Police Emergency Response',
              subtitle: 'Local police, highway patrols & rescue escorts',
              number: '112',
              icon: Icons.local_police_rounded,
              color: const Color(0xFF4F46E5),
              onTap: () => _makeCall('112'),
            ),
            const SizedBox(height: 10),
            _HotlineCard(
              title: 'Medical Ambulance & Paramedics',
              subtitle: 'Emergency trauma care, ambulance dispatch',
              number: '108',
              icon: Icons.medical_services_rounded,
              color: const Color(0xFF10B981),
              onTap: () => _makeCall('108'),
            ),
            const SizedBox(height: 10),
            _HotlineCard(
              title: 'Fire & Rescue Brigade',
              subtitle: 'Structural fires, chemical spills & collapse extrication',
              number: '101',
              icon: Icons.local_fire_department_rounded,
              color: const Color(0xFFEA580C),
              onTap: () => _makeCall('101'),
            ),
            const SizedBox(height: 10),
            _HotlineCard(
              title: 'Women & Child Emergency Helpline',
              subtitle: '24/7 dedicated safety support & crisis shelter',
              number: '1091',
              icon: Icons.support_agent_rounded,
              color: const Color(0xFFD946EF),
              onTap: () => _makeCall('1091'),
            ),

            const SizedBox(height: 28),

            // Emergency Survival Go-Bag Checklist
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.backpack_outlined, color: Color(0xFF0284C7), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Emergency Go-Bag',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_emergencyKitItems.values.where((v) => v).length}/${_emergencyKitItems.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Essential items to keep ready for evacuation:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 14),
                  ..._emergencyKitItems.entries.map((entry) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _emergencyKitItems[entry.key] = !entry.value;
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: entry.value ? const Color(0xFF10B981) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: entry.value
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFCBD5E1),
                                  width: 1.8,
                                ),
                              ),
                              child: entry.value
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: entry.value
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF334155),
                                  decoration: entry.value ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HotlineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HotlineCard({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
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
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_rounded, color: color, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        number,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
