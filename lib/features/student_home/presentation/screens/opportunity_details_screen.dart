import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/services/bookmark_service.dart';
import '../../../auth/providers/auth_providers.dart';

class OpportunityDetailsScreen extends ConsumerWidget {
  final String id;

  const OpportunityDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oppAsync = ref.watch(opportunityDetailsProvider(id));
    final studentId = ref.watch(currentUserProvider).value?.uid ?? 'kofi-annan-uid';
    final bookmarkStream = ref.watch(isBookmarkedStreamProvider((studentId: studentId, opportunityId: id)));
    final isBookmarked = bookmarkStream.value ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Opportunity Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: oppAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading opportunity: $err')),
        data: (opp) {
          if (opp == null) {
            return const Center(child: Text('Opportunity not found.'));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Card Block
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Rounded Logo Card
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.wb_sunny_outlined,
                                color: AppColors.primary,
                                size: 44,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Text(
                            opp.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 6),
                          // Company Link
                          GestureDetector(
                            onTap: () {
                              context.push('/student/employer/${opp.employerId}');
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                opp.company,
                                style: const TextStyle(
                                  color: Color(0xFF1E88E5),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMatchBadge('High Match', const Color(0xFFE8F8F0), const Color(0xFF27AE60), Icons.check_circle_outline),
                              const SizedBox(width: 10),
                              _buildMatchBadge(opp.industry, const Color(0xFFE8F4FD), Colors.blue, Icons.eco_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Info Cards (2x3 grid)
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildInfoGridCard(Icons.account_balance_wallet_outlined, 'Stipend', opp.stipend),
                            const SizedBox(width: 12),
                            _buildInfoGridCard(Icons.access_time, 'Duration', opp.duration),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildInfoGridCard(Icons.location_on_outlined, 'Location', '${opp.locationMode} (${opp.locationName})'),
                            const SizedBox(width: 12),
                            _buildInfoGridCard(Icons.people_outline, 'Openings', opp.openings),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildInfoGridCard(
                              Icons.calendar_today_outlined,
                              'Deadline',
                              '${opp.deadline.day}/${opp.deadline.month}/${opp.deadline.year} ${opp.deadline.hour.toString().padLeft(2, '0')}:${opp.deadline.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Role Description
                    _buildSectionContainer(
                      icon: Icons.description_outlined,
                      title: 'Role Description',
                      child: Text(
                        opp.description,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Requirements
                    _buildSectionContainer(
                      icon: Icons.checklist_outlined,
                      title: 'Requirements',
                      child: Column(
                        children: opp.requirements.map((req) => _buildRequirementRow(req)).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. Compensation & Perks
                    _buildSectionContainer(
                      icon: Icons.wallet_giftcard_outlined,
                      title: 'Compensation & Perks',
                      child: Column(
                        children: [
                          _buildCompensationRow('Monthly Stipend', opp.stipend),
                          _buildCompensationRow('Learning Budget', '\$500 Annual Credit'),
                          _buildCompensationRow('Hardware', 'Company Laptop Provided'),
                          _buildCompensationRow('Health Cover', 'Premium Global Insurance'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Sticky Bottom Action Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Save Button
                      OutlinedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await ref.read(bookmarkServiceProvider).toggleBookmark(studentId, id);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked ? 'Removed from Bookmarks!' : 'Saved to Bookmarks!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Apply Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: DateTime.now().isAfter(opp.deadline)
                              ? null
                              : () {
                                  context.push('/student/apply/$id');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DateTime.now().isAfter(opp.deadline) ? Colors.grey : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateTime.now().isAfter(opp.deadline) ? 'Application Closed' : 'Apply Now',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                DateTime.now().isAfter(opp.deadline) ? Icons.lock_outline : Icons.arrow_forward,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMatchBadge(String text, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGridCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E6E6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF27AE60),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompensationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
