import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../auth/providers/auth_providers.dart';
import '../widgets/employer_home_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/active_role_item.dart';
import '../widgets/hire_talent_card.dart';
import '../widgets/smart_matching_card.dart';
import 'employer_main_scaffold.dart';

class EmployerHomeFeed extends ConsumerWidget {
  const EmployerHomeFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final uid = user?.uid ?? 'lumen-energy-uid';
    final orgName = user?.fullName ?? 'Lumen-Energy';

    final oppsAsync = ref.watch(employerOpportunitiesProvider(uid));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmployerHomeHeader(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $orgName',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Here is an overview of your current talent\nacquisition metrics.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    oppsAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Error loading dashboard: $err'),
                        ),
                      ),
                      data: (opportunities) {
                        if (opportunities.isEmpty) {
                          // Standard startup empty-state widget telling them to start posting
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFF0F0)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.work_outline, size: 48, color: AppColors.primary),
                                const SizedBox(height: 16),
                                const Text(
                                  'Get Started by Posting your First Role',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'You have not published any opportunities yet. Connect with top ALU talent in minutes.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ref.read(employerTabProvider.notifier).setTab(1); // Set post tab
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Start Posting', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        }

                        // Aggregate applicants
                        int totalApplicants = 0;
                        for (var opp in opportunities) {
                          totalApplicants += opp.applicantsCount;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Metrics Cards
                            MetricCard(
                              title: 'Active Postings',
                              value: '${opportunities.length}',
                              trend: 'Live opportunities',
                              icon: Icons.assignment_outlined,
                            ),
                            MetricCard(
                              title: 'Total Applicants',
                              value: '$totalApplicants',
                              trend: 'Total candidates applied',
                              icon: Icons.people_outline,
                              valueColor: const Color(0xFF3B5B8C), // Steel blue
                            ),
                            const SizedBox(height: 24),
                            
                            // Active Roles Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Active Roles',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ref.read(employerTabProvider.notifier).setTab(2); // Set applicants tab
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'View Applicants',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Active Roles List
                            ...opportunities.map((opp) {
                              IconData icon = Icons.solar_power_outlined;
                              if (opp.title.toLowerCase().contains('analyst')) {
                                icon = Icons.analytics_outlined;
                              } else if (opp.title.toLowerCase().contains('writer') || opp.title.toLowerCase().contains('content')) {
                                icon = Icons.edit_note_outlined;
                              }
                              return ActiveRoleItem(
                                icon: icon,
                                title: opp.title,
                                details: '${opp.industry} • ${opp.type} • ${opp.locationMode}',
                                badgeText: '${opp.applicantsCount} Applicants',
                              );
                            }),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    // Call to Action Cards
                    const HireTalentCard(),
                    const SmartMatchingCard(),
                    const SizedBox(height: 48), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
