import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/disaster_controller.dart';
import 'home_screen.dart';
import 'alert_screen.dart';
import 'report_screen.dart';
import 'emergency_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Initialize controller globally
  final DisasterController controller = Get.put(DisasterController());

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateToTab: _onTabSelected),
      AlertsScreen(),
      const ReportScreen(),
      const EmergencyScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: _currentIndex == 0,
                  onTap: () => _onTabSelected(0),
                ),
                _NavBarItem(
                  icon: Icons.notifications_active_rounded,
                  label: 'Live Alerts',
                  isSelected: _currentIndex == 1,
                  badgeCount: controller.redAlertCount > 0 ? controller.redAlertCount : null,
                  onTap: () => _onTabSelected(1),
                ),
                _NavBarItem(
                  icon: Icons.add_alert_rounded,
                  label: 'Report',
                  isSelected: _currentIndex == 2,
                  onTap: () => _onTabSelected(2),
                ),
                _NavBarItem(
                  icon: Icons.emergency_rounded,
                  label: 'SOS Helpline',
                  isSelected: _currentIndex == 3,
                  isEmergency: true,
                  onTap: () => _onTabSelected(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isEmergency;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color(0xFF0F172A);
    if (isEmergency) {
      selectedColor = const Color(0xFFEF4444);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? selectedColor
                      : (isEmergency ? const Color(0xFFEF4444).withValues(alpha: 0.7) : const Color(0xFF94A3B8)),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? selectedColor
                    : (isEmergency ? const Color(0xFFEF4444).withValues(alpha: 0.8) : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
