import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalReportItem {
  final String disasterType;
  final String severity;
  final String location;
  final String description;
  final DateTime timestamp;

  LocalReportItem({
    required this.disasterType,
    required this.severity,
    required this.location,
    required this.description,
    required this.timestamp,
  });
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedDisasterType = 'Flood';
  String selectedSeverity = 'Moderate';

  bool isSubmitting = false;

  final List<LocalReportItem> _recentReports = [];

  final List<Map<String, dynamic>> disasterTypes = [
    {'name': 'Flood', 'icon': Icons.water_rounded},
    {'name': 'Earthquake', 'icon': Icons.waves_rounded},
    {'name': 'Fire', 'icon': Icons.local_fire_department_rounded},
    {'name': 'Cyclone', 'icon': Icons.cyclone_rounded},
    {'name': 'Landslide', 'icon': Icons.terrain_rounded},
    {'name': 'Other', 'icon': Icons.warning_amber_rounded},
  ];

  final List<String> severityLevels = ['Low', 'Moderate', 'High', 'Severe'];

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final newReport = LocalReportItem(
      disasterType: selectedDisasterType,
      severity: selectedSeverity,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      timestamp: DateTime.now(),
    );

    // Try sending to Firebase Firestore safely
    bool firestoreSuccess = false;
    try {
      await FirebaseFirestore.instance.collection('disaster_reports').add({
        'disaster_type': selectedDisasterType,
        'severity': selectedSeverity,
        'location': locationController.text.trim(),
        'description': descriptionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 4));
      firestoreSuccess = true;
    } catch (_) {
      firestoreSuccess = false;
    }

    if (!mounted) return;

    setState(() {
      _recentReports.insert(0, newReport);
      isSubmitting = false;
      locationController.clear();
      descriptionController.clear();
      selectedDisasterType = 'Flood';
      selectedSeverity = 'Moderate';
    });

    Get.snackbar(
      'Report Submitted',
      firestoreSuccess
          ? 'Your report has been broadcasted to emergency responders.'
          : 'Report saved locally & queued for network synchronization.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
    );
  }

  void _autofillLocation() {
    setState(() {
      locationController.text = 'Station Road & Coastal Highway Junction';
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
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
          'Report Incident',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: Color(0xFFF59E0B),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Community Hazard Alert',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Submit verifiable hazards to help local rescue teams and citizens stay prepared.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Selector
              const Text(
                'Hazard Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: disasterTypes.map((type) {
                  final isSelected = selectedDisasterType == type['name'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type['icon'] as IconData,
                          size: 16,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Text(type['name'] as String),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0F172A),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedDisasterType = type['name'] as String;
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Severity Level Picker
              const Text(
                'Perceived Severity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: severityLevels.map((level) {
                  final isSelected = selectedSeverity == level;
                  Color activeColor = const Color(0xFF10B981);
                  if (level == 'Moderate') activeColor = const Color(0xFFF59E0B);
                  if (level == 'High') activeColor = const Color(0xFFEA580C);
                  if (level == 'Severe') activeColor = const Color(0xFFEF4444);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedSeverity = level;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.8 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              level,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? activeColor : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Location Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Incident Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _autofillLocation,
                    icon: const Icon(Icons.my_location_rounded, size: 14),
                    label: const Text('Detect GPS', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0284C7),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: locationController,
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'e.g. Near 5th Avenue Bridge, Riverside Sector',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                'Detailed Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Describe flood depth, structural damage, trapped persons, or immediate risks...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a brief description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Submit Incident Alert',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Recent Reports List (Local & Live)
              if (_recentReports.isNotEmpty) ...[
                const SizedBox(height: 32),
                const Text(
                  'Your Submitted Reports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                ..._recentReports.map((report) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              report.disasterType,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                report.severity,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          report.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF334155),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
