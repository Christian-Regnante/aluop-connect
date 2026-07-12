import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/application_service.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/models/application_model.dart';
import '../../../auth/providers/auth_providers.dart';

class ApplicantReviewHubScreen extends ConsumerStatefulWidget {
  const ApplicantReviewHubScreen({super.key});

  @override
  ConsumerState<ApplicantReviewHubScreen> createState() => _ApplicantReviewHubScreenState();
}

class _ApplicantReviewHubScreenState extends ConsumerState<ApplicantReviewHubScreen> {
  int _activeFilter = 0; // 0: All, 1: Unreviewed, 2: Interview, 3: Accepted

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final employerId = user?.uid ?? 'lumen-energy-uid';
    final appsAsync = ref.watch(employerApplicationsProvider(employerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        user != null ? _getInitials(user.fullName) : 'AO',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AluOp-Connect',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.0,
                            ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Hiring Dashboard',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications_none,
                    size: 26,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),

            // 2. Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Applicants',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 28,
                    ),
              ),
            ),
            
            // 3. Sub-title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Active Role Submissions',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Horizontal filter chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildFilterTab('All', index: 0),
                  const SizedBox(width: 10),
                  _buildFilterTab('Unreviewed', index: 1),
                  const SizedBox(width: 10),
                  _buildFilterTab('Interview', index: 2),
                  const SizedBox(width: 10),
                  _buildFilterTab('Accepted', index: 3),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Applicants List
            Expanded(
              child: appsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (applications) {
                  // Filter applications
                  final filtered = applications.where((app) {
                    if (_activeFilter == 0) return true;
                    if (_activeFilter == 1) return app.status == 'Applied';
                    if (_activeFilter == 2) return app.status == 'Interview';
                    if (_activeFilter == 3) return app.status == 'Accepted';
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'No applicants in this category.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final app = filtered[idx];
                      return _ApplicantCard(app: app);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, {required int index}) {
    final isSelected = _activeFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ApplicantCard extends ConsumerWidget {
  final ApplicationModel app;

  const _ApplicantCard({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final opportunityService = ref.watch(opportunityServiceProvider);

    // Get applicant status tag attributes
    Color tagBg = const Color(0xFFE8F4FD);
    Color tagTextColor = Colors.blue;
    if (app.status == 'Interview') {
      tagBg = const Color(0xFFFFFDE7);
      tagTextColor = Colors.orange;
    } else if (app.status == 'Accepted') {
      tagBg = const Color(0xFFE8F8F0);
      tagTextColor = const Color(0xFF27AE60);
    } else if (app.status == 'Closed') {
      tagBg = const Color(0xFFFFF0F0);
      tagTextColor = AppColors.primary;
    }

    final diff = DateTime.now().difference(app.appliedAt);
    String timeText = 'Applied just now';
    if (diff.inDays > 0) {
      timeText = 'Applied ${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      timeText = 'Applied ${diff.inHours} hours ago';
    }

    return FutureBuilder(
      future: authService.getUserData(app.studentId),
      builder: (context, userSnapshot) {
        final displayName = userSnapshot.data?.fullName ?? 'Student Candidate';
        final initials = _getInitials(displayName);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Dynamic opportunity title load
                        FutureBuilder(
                          future: opportunityService.getOpportunity(app.opportunityId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text(
                                'For: ${snapshot.data!.title}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            return const Text(
                              'For Opportunity...',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  app.status.toUpperCase(),
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD5D5), width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_border, color: AppColors.primary, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Academic Star',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ALU Student',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFFDE8E8), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeText,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/employer/evaluation/${app.studentId}');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Profile',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
            ],
          ),
        );
      },
    );
  }
}

String _getInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.isEmpty) return '';
  if (words.length == 1) {
    return words[0].length >= 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
  }
  return '${words[0][0]}${words[1][0]}'.toUpperCase();
}
