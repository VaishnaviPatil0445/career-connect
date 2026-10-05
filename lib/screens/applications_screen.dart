import 'package:flutter/material.dart';
import '../data/sample_jobs.dart';
import '../models/job.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import 'job_details_screen.dart';

/// Neo-Brutalist Applications Screen.
class ApplicationsScreen extends StatefulWidget {
  final VoidCallback? onBrowseTapped;

  const ApplicationsScreen({super.key, this.onBrowseTapped});

  @override
  State<ApplicationsScreen> createState() => ApplicationsScreenState();
}

class ApplicationsScreenState extends State<ApplicationsScreen> {
  // Map of Job -> applied date string
  Map<Job, String> _appliedJobMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAppliedJobs();
  }

  /// Reloads application records from SharedPreferences. Can be called from parent.
  Future<void> loadAppliedJobs() async {
    final map = await StorageService.getAppliedJobs();
    final Map<Job, String> matched = {};

    for (final entry in map.entries) {
      final job = sampleJobs.firstWhere(
        (j) => j.id == entry.key,
        orElse: () => const Job(
          id: '',
          title: 'Unknown Role',
          company: 'Unknown',
          location: '',
          jobType: '',
          workMode: '',
          salary: '',
          description: '',
          responsibilities: [],
          requirements: [],
          skills: [],
          companyLogoText: '?',
          postedDate: '',
        ),
      );
      if (job.id.isNotEmpty) {
        matched[job] = entry.value;
      }
    }

    if (mounted) {
      setState(() {
        _appliedJobMap = matched;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _appliedJobMap.entries.toList();

    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          if (entries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neoGreen,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.neoBlack, width: 1.5),
                    boxShadow: AppColors.neoShadow(offset: 1.5),
                  ),
                  child: Text(
                    '${entries.length} Applied',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neoBlack,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.neoBlack))
          : entries.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle, size: 16, color: AppColors.neoBlack),
                          SizedBox(width: 6),
                          Text(
                            'Applications tracked in local storage',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final job = entries[index].key;
                          final appliedDate = entries[index].value;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.neoBlack, width: 2.5),
                              boxShadow: AppColors.neoShadow(offset: 4),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailsScreen(job: job),
                                    ),
                                  );
                                  loadAppliedJobs();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top Row: Company monogram, Title, Status badge
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 46,
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: AppColors.neoYellow,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.neoBlack, width: 2),
                                              boxShadow: AppColors.neoShadow(offset: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              job.companyLogoText,
                                              style: const TextStyle(
                                                color: AppColors.neoBlack,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  job.title,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                    color: AppColors.neoBlack,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  job.company,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Status Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.neoGreen,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: AppColors.neoBlack,
                                                width: 1.5,
                                              ),
                                              boxShadow: AppColors.neoShadow(offset: 1.5),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 13,
                                                  color: AppColors.neoBlack,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Applied',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                    color: AppColors.neoBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),
                                      const Divider(height: 1, color: AppColors.neoBlack, thickness: 1.2),
                                      const SizedBox(height: 10),

                                      // Bottom Row: Location, Work Mode, Applied Date
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${job.location} • ${job.workMode}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F4F6),
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: AppColors.neoBlack, width: 1.2),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 11,
                                                  color: AppColors.neoBlack,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Applied $appliedDate',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.neoBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neoBlack, width: 2.5),
            boxShadow: AppColors.neoShadow(offset: 4.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.neoPink,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neoBlack, width: 2),
                ),
                child: const Icon(
                  Icons.send,
                  size: 48,
                  color: AppColors.neoBlack,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No applications yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neoBlack,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'When you apply for internships or jobs, your applications will be tracked here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (widget.onBrowseTapped != null) {
                    widget.onBrowseTapped!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.neoYellow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.neoBlack, width: 2),
                    boxShadow: AppColors.neoShadow(offset: 2.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 18, color: AppColors.neoBlack),
                      SizedBox(width: 8),
                      Text(
                        'Explore Jobs',
                        style: TextStyle(
                          color: AppColors.neoBlack,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
