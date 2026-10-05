import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';

/// Neo-Brutalist Job Details Screen.
class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isSaved = false;
  bool _isApplied = false;
  String? _appliedDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final saved = await StorageService.isJobSaved(widget.job.id);
    final applied = await StorageService.isJobApplied(widget.job.id);
    final date = await StorageService.getAppliedDate(widget.job.id);

    if (mounted) {
      setState(() {
        _isSaved = saved;
        _isApplied = applied;
        _appliedDate = date;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSaveToggle() async {
    final messenger = ScaffoldMessenger.of(context);
    final newSavedStatus = await StorageService.toggleSavedJob(widget.job.id);
    if (!mounted) return;

    setState(() {
      _isSaved = newSavedStatus;
    });

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: newSavedStatus ? AppColors.neoYellow : Colors.white,
        content: Row(
          children: [
            Icon(
              newSavedStatus ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.neoBlack,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              newSavedStatus ? 'Job added to bookmarks!' : 'Job removed from bookmarks.',
              style: const TextStyle(
                color: AppColors.neoBlack,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleApply() async {
    if (_isApplied) return;

    final messenger = ScaffoldMessenger.of(context);
    final success = await StorageService.applyJob(widget.job.id);
    if (!mounted) return;

    if (success) {
      final date = await StorageService.getAppliedDate(widget.job.id);
      if (!mounted) return;

      setState(() {
        _isApplied = true;
        _appliedDate = date;
      });

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.neoGreen,
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.neoBlack, size: 22),
              SizedBox(width: 8),
              Text(
                'Application saved successfully.',
                style: TextStyle(
                  color: AppColors.neoBlack,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInternship = widget.job.jobType.toLowerCase().contains('intern');
    final isRemote = widget.job.workMode.toLowerCase().contains('remote');

    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _handleSaveToggle,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isSaved ? AppColors.neoYellow : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.neoBlack, width: 2),
                  boxShadow: AppColors.neoShadow(offset: 2),
                ),
                child: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.neoBlack,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.neoBlack))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company & Title Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.neoBlack, width: 2.5),
                      boxShadow: AppColors.neoShadow(offset: 4.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.neoYellow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neoBlack, width: 2),
                            boxShadow: AppColors.neoShadow(offset: 2.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.job.companyLogoText,
                            style: const TextStyle(
                              color: AppColors.neoBlack,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.job.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.neoBlack,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.job.company,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: AppColors.neoBlack,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.job.location,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Applied Banner if user has applied
                  if (_isApplied) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.neoGreen,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neoBlack, width: 2.5),
                        boxShadow: AppColors.neoShadow(offset: 3),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.neoBlack, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Application Submitted!',
                                  style: TextStyle(
                                    color: AppColors.neoBlack,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_appliedDate != null)
                                  Text(
                                    'Applied on $_appliedDate',
                                    style: const TextStyle(
                                      color: AppColors.neoBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Overview Highlights 2x2 Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildNeoDetailBox(
                          label: 'Job Type',
                          value: widget.job.jobType,
                          icon: Icons.badge_outlined,
                          bgColor: isInternship ? AppColors.neoCyan : AppColors.neoYellow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNeoDetailBox(
                          label: 'Work Mode',
                          value: widget.job.workMode,
                          icon: Icons.laptop_chromebook,
                          bgColor: isRemote ? AppColors.neoGreen : AppColors.neoPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNeoDetailBox(
                          label: isInternship ? 'Stipend' : 'Salary',
                          value: widget.job.salary,
                          icon: Icons.payments_outlined,
                          bgColor: AppColors.neoYellow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNeoDetailBox(
                          label: 'Posted Date',
                          value: widget.job.postedDate,
                          icon: Icons.schedule,
                          bgColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // Required Skills
                  _buildNeoSectionTitle('Required Skills'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.job.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.neoBlack, width: 2),
                          boxShadow: AppColors.neoShadow(offset: 2),
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

                  const SizedBox(height: 26),

                  // About The Role (Description)
                  _buildNeoSectionTitle('About the Role'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neoBlack, width: 2),
                      boxShadow: AppColors.neoShadow(offset: 3),
                    ),
                    child: Text(
                      widget.job.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Responsibilities
                  _buildNeoSectionTitle('Key Responsibilities'),
                  const SizedBox(height: 10),
                  ...widget.job.responsibilities.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 12),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.neoGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neoBlack, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: AppColors.neoBlack,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Requirements
                  _buildNeoSectionTitle('Eligibility & Requirements'),
                  const SizedBox(height: 10),
                  ...widget.job.requirements.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 3, right: 12),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.neoPink,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neoBlack, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 11,
                              color: AppColors.neoBlack,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.neoBlack, width: 2.5)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Save / Bookmark Button
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: _handleSaveToggle,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _isSaved ? AppColors.neoYellow : Colors.white,
                    foregroundColor: AppColors.neoBlack,
                    side: const BorderSide(color: AppColors.neoBlack, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 18,
                    color: AppColors.neoBlack,
                  ),
                  label: Text(
                    _isSaved ? 'Saved' : 'Save Job',
                    style: const TextStyle(
                      color: AppColors.neoBlack,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Apply Now Button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isApplied ? null : _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isApplied ? const Color(0xFFE5E7EB) : AppColors.neoGreen,
                    foregroundColor: AppColors.neoBlack,
                    disabledBackgroundColor: const Color(0xFFE5E7EB),
                    disabledForegroundColor: AppColors.neoBlack,
                    side: const BorderSide(color: AppColors.neoBlack, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  icon: Icon(
                    _isApplied ? Icons.check_circle : Icons.send,
                    size: 18,
                    color: AppColors.neoBlack,
                  ),
                  label: Text(
                    _isApplied ? 'Applied' : 'Apply Now',
                    style: const TextStyle(
                      color: AppColors.neoBlack,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeoSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neoYellow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.neoBlack, width: 1.5),
        boxShadow: AppColors.neoShadow(offset: 1.5),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.neoBlack,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildNeoDetailBox({
    required String label,
    required String value,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.neoBlack, width: 2),
        boxShadow: AppColors.neoShadow(offset: 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.neoBlack),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neoBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.neoBlack,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
