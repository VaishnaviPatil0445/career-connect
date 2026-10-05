import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';

/// Neo-Brutalist Profile Screen.
class ProfileScreen extends StatefulWidget {
  final VoidCallback? onSavedStatTap;
  final VoidCallback? onAppliedStatTap;

  const ProfileScreen({
    super.key,
    this.onSavedStatTap,
    this.onAppliedStatTap,
  });

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  int _savedCount = 0;
  int _appliedCount = 0;
  bool _isLoading = true;

  final List<String> _studentSkills = const [
    'Java',
    'Flutter',
    'React',
    'Python',
    'SQL',
    'Git',
    'Data Structures',
  ];

  @override
  void initState() {
    super.initState();
    loadProfileStats();
  }

  /// Reloads counts from SharedPreferences. Can be called from parent.
  Future<void> loadProfileStats() async {
    final savedIds = await StorageService.getSavedJobIds();
    final appliedJobs = await StorageService.getAppliedJobs();

    if (mounted) {
      setState(() {
        _savedCount = savedIds.length;
        _appliedCount = appliedJobs.length;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.neoBlack))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Neo Profile Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neoBlack, width: 2.5),
                      boxShadow: AppColors.neoShadow(offset: 4.5),
                    ),
                    child: Column(
                      children: [
                        // Neo Avatar Box
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.neoYellow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.neoBlack, width: 2.5),
                            boxShadow: AppColors.neoShadow(offset: 3),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'SU',
                            style: TextStyle(
                              color: AppColors.neoBlack,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Name
                        const Text(
                          'Student User',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neoBlack,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Degree / Role
                        const Text(
                          'B.Tech Computer Science Student',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // University / Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.neoGreen,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.neoBlack, width: 1.5),
                            boxShadow: AppColors.neoShadow(offset: 2),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.school, size: 14, color: AppColors.neoBlack),
                              SizedBox(width: 6),
                              Text(
                                'Class of 2026 • Seeking Roles',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.neoBlack,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Real Statistics Row
                  Row(
                    children: [
                      // Saved Jobs Stat
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onSavedStatTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.neoCyan,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.neoBlack, width: 2.5),
                              boxShadow: AppColors.neoShadow(offset: 4),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.bookmark,
                                  color: AppColors.neoBlack,
                                  size: 26,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_savedCount',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.neoBlack,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Saved Jobs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neoBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Applied Jobs Stat
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onAppliedStatTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.neoPink,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.neoBlack, width: 2.5),
                              boxShadow: AppColors.neoShadow(offset: 4),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.send,
                                  color: AppColors.neoBlack,
                                  size: 26,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_appliedCount',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.neoBlack,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Applied Jobs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neoBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Technical Skills Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neoBlack, width: 2.5),
                      boxShadow: AppColors.neoShadow(offset: 4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.code, size: 22, color: AppColors.neoBlack),
                            SizedBox(width: 8),
                            Text(
                              'Technical Skills',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.neoBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _studentSkills.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neoYellow,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.neoBlack,
                                  width: 1.5,
                                ),
                                boxShadow: AppColors.neoShadow(offset: 1.5),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.neoBlack,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Education & Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neoBlack, width: 2.5),
                      boxShadow: AppColors.neoShadow(offset: 4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.school, size: 22, color: AppColors.neoBlack),
                            SizedBox(width: 8),
                            Text(
                              'Education & Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.neoBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildNeoInfoRow(
                          icon: Icons.school_outlined,
                          label: 'Program',
                          value: 'B.Tech in Computer Science',
                        ),
                        const Divider(height: 18, color: AppColors.neoBlack, thickness: 1.2),
                        _buildNeoInfoRow(
                          icon: Icons.location_city,
                          label: 'Preferred Location',
                          value: 'Pune / Bengaluru / Remote',
                        ),
                        const Divider(height: 18, color: AppColors.neoBlack, thickness: 1.2),
                        _buildNeoInfoRow(
                          icon: Icons.work_history,
                          label: 'Looking For',
                          value: 'Internships & Entry-Level Roles',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Version / Student Project Note
                  const Center(
                    child: Text(
                      'CareerConnect • Neo-Brutalist Edition\nBuilt with Flutter & Dart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNeoInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.neoBlack),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neoBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
