import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'student_home_feed.dart';
import 'explore_screen.dart';
import 'applications_tracker_screen.dart';
import 'student_profile_screen.dart';

class StudentTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

final studentTabProvider = NotifierProvider<StudentTabNotifier, int>(() => StudentTabNotifier());

class StudentMainScaffold extends ConsumerStatefulWidget {
  const StudentMainScaffold({super.key});

  @override
  ConsumerState<StudentMainScaffold> createState() => _StudentMainScaffoldState();
}

class _StudentMainScaffoldState extends ConsumerState<StudentMainScaffold> {
  final List<Widget> _screens = [
    const StudentHomeFeed(),
    const ExploreScreen(),
    const ApplicationsTrackerScreen(),
    const StudentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(studentTabProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0, currentIndex: currentIndex),
                _buildNavItem(icon: Icons.search, label: 'Explore', index: 1, currentIndex: currentIndex),
                _buildNavItem(icon: Icons.description_outlined, label: 'Applications', index: 2, currentIndex: currentIndex),
                _buildNavItem(icon: Icons.person_outline, label: 'Profile', index: 3, currentIndex: currentIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(studentTabProvider.notifier).setTab(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
