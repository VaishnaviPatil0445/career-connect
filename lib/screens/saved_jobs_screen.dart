import 'package:flutter/material.dart';
import '../data/sample_jobs.dart';
import '../models/job.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';

/// Neo-Brutalist Saved Jobs Screen.
class SavedJobsScreen extends StatefulWidget {
  final VoidCallback? onDataChanged;
  final VoidCallback? onBrowseTapped;

  const SavedJobsScreen({
    super.key,
    this.onDataChanged,
    this.onBrowseTapped,
  });

  @override
  State<SavedJobsScreen> createState() => SavedJobsScreenState();
}

class SavedJobsScreenState extends State<SavedJobsScreen> {
  List<Job> _savedJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSavedJobs();
  }

  /// Reloads saved jobs from SharedPreferences. Can be called from parent.
  Future<void> loadSavedJobs() async {
    final savedIds = await StorageService.getSavedJobIds();
    final matching = sampleJobs.where((j) => savedIds.contains(j.id)).toList();

    if (mounted) {
      setState(() {
        _savedJobs = matching;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(Job job) async {
    await StorageService.toggleSavedJob(job.id);
    await loadSavedJobs();
    widget.onDataChanged?.call();

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: const Row(
          children: [
            Icon(Icons.bookmark_remove, color: AppColors.neoBlack, size: 20),
            SizedBox(width: 8),
            Text(
              'Job removed from saved list.',
              style: TextStyle(
                color: AppColors.neoBlack,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.neoBlack, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        actions: [
          if (_savedJobs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neoYellow,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.neoBlack, width: 1.5),
                    boxShadow: AppColors.neoShadow(offset: 1.5),
                  ),
                  child: Text(
                    '${_savedJobs.length} Bookmarked',
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
          : _savedJobs.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, size: 16, color: AppColors.neoBlack),
                          SizedBox(width: 6),
                          Text(
                            'Your bookmarked opportunities (stored locally)',
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
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: _savedJobs.length,
                        itemBuilder: (context, index) {
                          final job = _savedJobs[index];
                          return JobCard(
                            job: job,
                            isSaved: true,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailsScreen(job: job),
                                ),
                              );
                              loadSavedJobs();
                              widget.onDataChanged?.call();
                            },
                            onBookmarkToggle: () => _removeBookmark(job),
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
                  color: AppColors.neoCyan,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neoBlack, width: 2),
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 48,
                  color: AppColors.neoBlack,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No saved jobs yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neoBlack,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bookmark interesting opportunities while browsing to view and review them later.',
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
                      Icon(Icons.explore, size: 18, color: AppColors.neoBlack),
                      SizedBox(width: 8),
                      Text(
                        'Browse Opportunities',
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
