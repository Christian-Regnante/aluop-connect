import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/application_service.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/services/bookmark_service.dart';
import '../../../../core/models/application_model.dart';
import '../../../auth/providers/auth_providers.dart';

class ApplicationsTrackerScreen extends ConsumerStatefulWidget {
  const ApplicationsTrackerScreen({super.key});

  @override
  ConsumerState<ApplicationsTrackerScreen> createState() => _ApplicationsTrackerScreenState();
}

class _ApplicationsTrackerScreenState extends ConsumerState<ApplicationsTrackerScreen> {
  int _activeTab = 0; // 0: Applied, 1: Interview, 2: Accepted, 3: Closed, 4: Saved

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final studentId = user?.uid ?? 'kofi-annan-uid';
    final appsAsync = ref.watch(studentApplicationsProvider(studentId));
    final bookmarkedIdsAsync = ref.watch(studentBookmarkedIdsProvider(studentId));

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
                        user != null ? _getInitials(user.fullName) : 'SA',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AluOp-Connect',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.notifications_none,
                    size: 26,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            // 2. Title & Active Count Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Applications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 22,
                        ),
                  ),
                  if (_activeTab != 4)
                    appsAsync.when(
                      loading: () => const SizedBox(),
                      error: (err, stack) => const SizedBox(),
                      data: (apps) {
                        final activeCount = apps.where((a) => a.status != 'Closed').length;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$activeCount Active',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    bookmarkedIdsAsync.when(
                      loading: () => const SizedBox(),
                      error: (err, stack) => const SizedBox(),
                      data: (ids) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${ids.length} Saved',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Tab headers
            appsAsync.when(
              loading: () => const SizedBox(),
              error: (err, stack) => const SizedBox(),
              data: (apps) {
                final appliedCount = apps.where((a) => a.status == 'Applied').length;
                final interviewCount = apps.where((a) => a.status == 'Interview').length;
                final acceptedCount = apps.where((a) => a.status == 'Accepted').length;
                final closedCount = apps.where((a) => a.status == 'Closed').length;

                return bookmarkedIdsAsync.when(
                  loading: () => const SizedBox(),
                  error: (err, stack) => const SizedBox(),
                  data: (savedIds) {
                    final savedCount = savedIds.length;
                    return SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: [
                          _buildTabHeader('Applied ($appliedCount)', index: 0),
                          const SizedBox(width: 24),
                          _buildTabHeader('Interview ($interviewCount)', index: 1),
                          const SizedBox(width: 24),
                          _buildTabHeader('Accepted ($acceptedCount)', index: 2),
                          const SizedBox(width: 24),
                          _buildTabHeader('Closed ($closedCount)', index: 3),
                          const SizedBox(width: 24),
                          _buildTabHeader('Saved ($savedCount)', index: 4),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // 4. Scrollable List of Applications or Bookmarks
            Expanded(
              child: _activeTab == 4
                  ? bookmarkedIdsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      error: (err, stack) => Center(child: Text('Error loading bookmarks: $err')),
                      data: (savedIds) {
                        if (savedIds.isEmpty) {
                          return const Center(
                            child: Text(
                              'No bookmarked opportunities yet.',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: savedIds.length,
                          itemBuilder: (context, idx) {
                            final oppId = savedIds[idx];
                            return _BookmarkedCardItem(opportunityId: oppId, studentId: studentId);
                          },
                        );
                      },
                    )
                  : appsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      error: (err, stack) => Center(child: Text('Error loading applications: $err')),
                      data: (apps) {
                        final filtered = apps.where((app) {
                          if (_activeTab == 0) return app.status == 'Applied';
                          if (_activeTab == 1) return app.status == 'Interview';
                          if (_activeTab == 2) return app.status == 'Accepted';
                          if (_activeTab == 3) return app.status == 'Closed';
                          return true;
                        }).toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text(
                              'No applications in this category.',
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
                            return _ApplicationCardItem(app: app);
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

  Widget _buildTabHeader(String label, {required int index}) {
    final isSelected = _activeTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Container(
              width: 24,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ApplicationCardItem extends ConsumerWidget {
  final ApplicationModel app;

  const _ApplicationCardItem({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oppService = ref.watch(opportunityServiceProvider);
    final appService = ref.watch(applicationServiceProvider);

    Color statusColor = const Color(0xFFE8F4FD);
    Color statusTextColor = Colors.blue;
    if (app.status == 'Interview') {
      statusColor = const Color(0xFFFFFDE7);
      statusTextColor = Colors.orange;
    } else if (app.status == 'Accepted') {
      statusColor = const Color(0xFFE8F8F0);
      statusTextColor = const Color(0xFF27AE60);
    } else if (app.status == 'Closed') {
      statusColor = const Color(0xFFFFF0F0);
      statusTextColor = AppColors.primary;
    }

    final diff = DateTime.now().difference(app.appliedAt);
    String appliedDateText = 'Applied today';
    if (diff.inDays > 0) {
      appliedDateText = 'Applied ${diff.inDays} days ago';
    }

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
          FutureBuilder(
            future: oppService.getOpportunity(app.opportunityId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final opp = snapshot.data!;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.wb_sunny_outlined, color: AppColors.primary, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opp.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${opp.company} • ${opp.locationMode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Text(
                'Loading Opportunity details...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appliedDateText,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  app.status.toUpperCase(),
                  style: TextStyle(
                    color: statusTextColor,
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
              TextButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await appService.deleteApplication(app.id);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Application withdrawn successfully.')),
                  );
                },
                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.primary),
                label: const Text(
                  'Withdraw Application',
                  style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookmarkedCardItem extends ConsumerWidget {
  final String opportunityId;
  final String studentId;

  const _BookmarkedCardItem({required this.opportunityId, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oppService = ref.watch(opportunityServiceProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
      ),
      child: FutureBuilder(
        future: oppService.getOpportunity(opportunityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox(height: 50, child: CircularProgressIndicator(color: AppColors.primary)));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opportunity unavailable', style: TextStyle(color: AppColors.textSecondary)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.primary),
                  onPressed: () async {
                    await ref.read(bookmarkServiceProvider).toggleBookmark(studentId, opportunityId);
                  },
                ),
              ],
            );
          }

          final opp = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.wb_sunny_outlined, color: AppColors.primary, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opp.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${opp.company} • ${opp.locationMode}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deadline: ${opp.deadline.day}/${opp.deadline.month}/${opp.deadline.year}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/student/opportunity/$opportunityId');
                    },
                    child: const Row(
                      children: [
                        Text('View Details', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

String _getInitials(String name) {
  if (name.trim().isEmpty) return 'SA';
  final parts = name.trim().split(' ');
  if (parts.length > 1) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
}
