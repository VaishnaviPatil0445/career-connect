import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import 'applications_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'saved_jobs_screen.dart';

/// Neo-Brutalist Main Navigation Screen with 4 tabs and live badges.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final GlobalKey<SavedJobsScreenState> _savedKey = GlobalKey<SavedJobsScreenState>();
  final GlobalKey<ApplicationsScreenState> _appliedKey = GlobalKey<ApplicationsScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey = GlobalKey<ProfileScreenState>();

  int _savedCount = 0;
  int _appliedCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshBadgeCounts();
  }

  Future<void> _refreshBadgeCounts() async {
    final savedIds = await StorageService.getSavedJobIds();
    final appliedJobs = await StorageService.getAppliedJobs();

    if (mounted) {
      setState(() {
        _savedCount = savedIds.length;
        _appliedCount = appliedJobs.length;
      });
      _savedKey.currentState?.loadSavedJobs();
      _appliedKey.currentState?.loadAppliedJobs();
      _profileKey.currentState?.loadProfileStats();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      _savedKey.currentState?.loadSavedJobs();
    } else if (index == 2) {
      _appliedKey.currentState?.loadAppliedJobs();
    } else if (index == 3) {
      _profileKey.currentState?.loadProfileStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onDataChanged: _refreshBadgeCounts,
      ),
      SavedJobsScreen(
        key: _savedKey,
        onDataChanged: _refreshBadgeCounts,
        onBrowseTapped: () => _onTabSelected(0),
      ),
      ApplicationsScreen(
        key: _appliedKey,
        onBrowseTapped: () => _onTabSelected(0),
      ),
      ProfileScreen(
        key: _profileKey,
        onSavedStatTap: () => _onTabSelected(1),
        onAppliedStatTap: () => _onTabSelected(2),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.neoBlack, width: 2.5)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _savedCount > 0,
                label: Text('$_savedCount', style: const TextStyle(fontWeight: FontWeight.w900)),
                backgroundColor: AppColors.neoPink,
                textColor: AppColors.neoBlack,
                child: const Icon(Icons.bookmark_outline),
              ),
              selectedIcon: Badge(
                isLabelVisible: _savedCount > 0,
                label: Text('$_savedCount', style: const TextStyle(fontWeight: FontWeight.w900)),
                backgroundColor: AppColors.neoPink,
                textColor: AppColors.neoBlack,
                child: const Icon(Icons.bookmark),
              ),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _appliedCount > 0,
                label: Text('$_appliedCount', style: const TextStyle(fontWeight: FontWeight.w900)),
                backgroundColor: AppColors.neoGreen,
                textColor: AppColors.neoBlack,
                child: const Icon(Icons.send_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: _appliedCount > 0,
                label: Text('$_appliedCount', style: const TextStyle(fontWeight: FontWeight.w900)),
                backgroundColor: AppColors.neoGreen,
                textColor: AppColors.neoBlack,
                child: const Icon(Icons.send),
              ),
              label: 'Applications',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
