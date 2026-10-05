import 'package:flutter/material.dart';
import '../data/sample_jobs.dart';
import '../models/job.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../widgets/job_card.dart';
import '../widgets/search_bar_widget.dart';
import 'job_details_screen.dart';

/// Neo-Brutalist Home screen for CareerConnect.
class HomeScreen extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const HomeScreen({super.key, this.onDataChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Search keyword
  String _searchQuery = '';

  // Quick category selection: 'All', 'Internships', 'Full Time', 'Remote'
  String _selectedQuickCategory = 'All';

  // Extended filters
  String? _filterJobType;
  String? _filterWorkMode;
  String? _filterLocation;

  // Saved job IDs for bookmark icon states
  Set<String> _savedJobIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedJobs() async {
    final list = await StorageService.getSavedJobIds();
    if (mounted) {
      setState(() {
        _savedJobIds = list.toSet();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBookmark(Job job) async {
    final isSaved = await StorageService.toggleSavedJob(job.id);
    if (!mounted) return;

    setState(() {
      if (isSaved) {
        _savedJobIds.add(job.id);
      } else {
        _savedJobIds.remove(job.id);
      }
    });

    widget.onDataChanged?.call();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isSaved ? AppColors.neoYellow : Colors.white,
        content: Row(
          children: [
            Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.neoBlack,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isSaved ? 'Job saved to bookmarks!' : 'Job removed from bookmarks.',
              style: const TextStyle(
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

  int get _activeExtendedFilterCount {
    int count = 0;
    if (_filterJobType != null) count++;
    if (_filterWorkMode != null) count++;
    if (_filterLocation != null) count++;
    return count;
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedQuickCategory = 'All';
      _filterJobType = null;
      _filterWorkMode = null;
      _filterLocation = null;
    });
  }

  List<Job> get _filteredJobs {
    return sampleJobs.where((job) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = job.title.toLowerCase().contains(q);
        final matchesCompany = job.company.toLowerCase().contains(q);
        final matchesLocation = job.location.toLowerCase().contains(q);
        final matchesSkills = job.skills.any((s) => s.toLowerCase().contains(q));

        if (!matchesTitle && !matchesCompany && !matchesLocation && !matchesSkills) {
          return false;
        }
      }

      if (_selectedQuickCategory == 'Internships') {
        if (!job.jobType.toLowerCase().contains('intern')) return false;
      } else if (_selectedQuickCategory == 'Full Time') {
        if (job.jobType.toLowerCase().contains('intern')) return false;
      } else if (_selectedQuickCategory == 'Remote') {
        if (!job.workMode.toLowerCase().contains('remote')) return false;
      }

      if (_filterJobType != null) {
        if (job.jobType.toLowerCase() != _filterJobType!.toLowerCase()) {
          return false;
        }
      }

      if (_filterWorkMode != null) {
        if (job.workMode.toLowerCase() != _filterWorkMode!.toLowerCase()) {
          return false;
        }
      }

      if (_filterLocation != null) {
        if (job.location.toLowerCase() != _filterLocation!.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _showFilterBottomSheet() {
    String? tempJobType = _filterJobType;
    String? tempWorkMode = _filterWorkMode;
    String? tempLocation = _filterLocation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neoBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.neoBlack, width: 2.5),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.neoBlack,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Opportunities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempJobType = null;
                              tempWorkMode = null;
                              tempLocation = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neoPink,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.neoBlack, width: 1.5),
                              boxShadow: AppColors.neoShadow(offset: 1.5),
                            ),
                            child: const Text(
                              'Reset All',
                              style: TextStyle(
                                color: AppColors.neoBlack,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.neoBlack, thickness: 1.5, height: 24),

                    // Job Type
                    const Text(
                      'Job Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.neoBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Internship', 'Full Time'].map((type) {
                        final isSelected = tempJobType == type;
                        return _buildModalNeoChip(
                          label: type,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() {
                              tempJobType = isSelected ? null : type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Work Mode
                    const Text(
                      'Work Mode',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.neoBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Remote', 'Hybrid', 'On-site'].map((mode) {
                        final isSelected = tempWorkMode == mode;
                        return _buildModalNeoChip(
                          label: mode,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() {
                              tempWorkMode = isSelected ? null : mode;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.neoBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Pune', 'Mumbai', 'Bengaluru', 'Remote'].map((loc) {
                        final isSelected = tempLocation == loc;
                        return _buildModalNeoChip(
                          label: loc,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() {
                              tempLocation = isSelected ? null : loc;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _filterJobType = tempJobType;
                          _filterWorkMode = tempWorkMode;
                          _filterLocation = tempLocation;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.neoYellow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.neoBlack, width: 2.5),
                          boxShadow: AppColors.neoShadow(offset: 3),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neoBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalNeoChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neoCyan : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neoBlack, width: 2),
          boxShadow: isSelected ? AppColors.neoShadow(offset: 2) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.neoBlack,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;

    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Title Section
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.neoYellow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.neoBlack, width: 2.5),
                      boxShadow: AppColors.neoShadow(offset: 3),
                    ),
                    child: const Icon(
                      Icons.work,
                      color: AppColors.neoBlack,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'CareerConnect',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Find your next opportunity',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Student & fresher badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.neoGreen,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neoBlack, width: 2),
                      boxShadow: AppColors.neoShadow(offset: 2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flash_on, size: 14, color: AppColors.neoBlack),
                        SizedBox(width: 3),
                        Text(
                          'Freshers',
                          style: TextStyle(
                            color: AppColors.neoBlack,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Neo Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              onClear: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              onFilterTap: _showFilterBottomSheet,
              activeFilterCount: _activeExtendedFilterCount,
            ),

            // Quick Filter Chips Row
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildNeoQuickChip('All', AppColors.neoYellow),
                  _buildNeoQuickChip('Internships', AppColors.neoCyan),
                  _buildNeoQuickChip('Full Time', AppColors.neoPink),
                  _buildNeoQuickChip('Remote', AppColors.neoGreen),
                ],
              ),
            ),

            // Active Filters Banner (if extended filters are active)
            if (_activeExtendedFilterCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neoYellow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.neoBlack, width: 2),
                    boxShadow: AppColors.neoShadow(offset: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 16, color: AppColors.neoBlack),
                      const SizedBox(width: 6),
                      Text(
                        '$_activeExtendedFilterCount filter${_activeExtendedFilterCount > 1 ? 's' : ''} active',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.neoBlack,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _filterJobType = null;
                            _filterWorkMode = null;
                            _filterLocation = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.neoBlack, width: 1.5),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neoBlack,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Results count / listings header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Opportunities (${jobs.length})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neoBlack,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.neoBlack, width: 1.5),
                    ),
                    child: const Text(
                      'Live Catalog',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.neoBlack,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List of Job Cards or Empty State
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.neoBlack))
                  : jobs.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            final isSaved = _savedJobIds.contains(job.id);

                            return JobCard(
                              job: job,
                              isSaved: isSaved,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailsScreen(job: job),
                                  ),
                                );
                                _loadSavedJobs();
                                widget.onDataChanged?.call();
                              },
                              onBookmarkToggle: () => _toggleBookmark(job),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeoQuickChip(String category, Color activeColor) {
    final isSelected = _selectedQuickCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedQuickCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neoBlack, width: 2),
            boxShadow: isSelected ? AppColors.neoShadow(offset: 2) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            category,
            style: TextStyle(
              color: AppColors.neoBlack,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neoPink,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neoBlack, width: 2),
                boxShadow: AppColors.neoShadow(offset: 2.5),
              ),
              child: const Icon(
                Icons.search_off,
                size: 38,
                color: AppColors.neoBlack,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No opportunities found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.neoBlack,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try searching with different keywords (e.g. "Flutter", "Java", "Pune") or reset your active filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _resetAllFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neoYellow,
                foregroundColor: AppColors.neoBlack,
                elevation: 0,
                side: const BorderSide(color: AppColors.neoBlack, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, size: 16, color: AppColors.neoBlack),
              label: const Text(
                'Clear search & filters',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
