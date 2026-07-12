import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'employer_home_feed.dart';
import 'post_engine_screen.dart';
import 'applicant_review_hub_screen.dart';
import 'employer_profile_screen.dart';

class EmployerTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

final employerTabProvider = NotifierProvider<EmployerTabNotifier, int>(() => EmployerTabNotifier());

class EmployerMainScaffold extends ConsumerStatefulWidget {
  const EmployerMainScaffold({super.key});

  @override
  ConsumerState<EmployerMainScaffold> createState() => _EmployerMainScaffoldState();
}

class _EmployerMainScaffoldState extends ConsumerState<EmployerMainScaffold> {
  final List<Widget> _screens = [
    const EmployerHomeFeed(),
    const PostEngineScreen(),
    const ApplicantReviewHubScreen(),
    const EmployerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(employerTabProvider);

    return Scaffold(
      body: _screens[currentIndex],
      floatingActionButton: currentIndex == 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                ref.read(employerTabProvider.notifier).setTab(1); // Navigates to Post step
              },
              backgroundColor: AppColors.primary,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 80.0, top: 12.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(icon: Icons.dashboard, label: 'Dashboard', index: 0, currentIndex: currentIndex),
                _buildNavItem(icon: Icons.add_circle_outline, label: 'Post', index: 1, currentIndex: currentIndex),
                _buildNavItem(icon: Icons.people_outline, label: 'Applicants', index: 2, currentIndex: currentIndex),
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

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(employerTabProvider.notifier).setTab(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 22,
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (!isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
