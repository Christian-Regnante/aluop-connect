import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/services/bookmark_service.dart';
import '../../../auth/providers/auth_providers.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeOppsAsync = ref.watch(activeOpportunitiesProvider);

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
                        ref.watch(currentUserProvider).value != null
                            ? _getInitials(ref.read(currentUserProvider).value!.fullName)
                            : 'SA',
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

            // 2. Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                    hintText: 'Search opportunities...',
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Filter Chips List
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildDropdownChip('Type: All', isSelected: true),
                  const SizedBox(width: 10),
                  _buildDropdownChip('Location: Remote', isSelected: false),
                  const SizedBox(width: 10),
                  _buildDropdownChip('Internships', isSelected: false, hasArrow: false),
                  const SizedBox(width: 10),
                  _buildDropdownChip('Micro-gigs', isSelected: false, hasArrow: false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Browse Opportunities Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Browse Opportunities',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 22,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Scrollable List of Opportunities
            Expanded(
              child: activeOppsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Error loading: $err')),
                data: (opportunities) {
                  final filtered = _getFilteredOpportunities(opportunities);

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'No matching opportunities found.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final opp = filtered[idx];
                      
                      IconData logoIcon = Icons.work;
                      Color logoBg = const Color(0xFF0F203C);
                      if (opp.title.toLowerCase().contains('analyst')) {
                        logoIcon = Icons.bar_chart;
                        logoBg = const Color(0xFF0B3A60);
                      } else if (opp.title.toLowerCase().contains('design') || opp.title.toLowerCase().contains('ui')) {
                        logoIcon = Icons.brush;
                        logoBg = const Color(0xFFF32E43);
                      } else if (opp.title.toLowerCase().contains('logistic') || opp.title.toLowerCase().contains('supply')) {
                        logoIcon = Icons.local_shipping;
                        logoBg = const Color(0xFF0F203C);
                      }

                      return _buildBrowseCard(
                        context: context,
                        id: opp.id,
                        title: opp.title,
                        company: opp.company,
                        location: opp.locationName,
                        type: opp.type,
                        tag1: opp.type,
                        tag2: opp.locationMode,
                        tag3: opp.duration,
                        logoBg: logoBg,
                        logoIcon: logoIcon,
                        deadline: opp.deadline,
                      );
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

  Widget _buildDropdownChip(String label, {required bool isSelected, bool hasArrow = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          if (hasArrow) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBrowseCard({
    required BuildContext context,
    required String id,
    required String title,
    required String company,
    required String location,
    required String type,
    required String tag1,
    required String tag2,
    required String tag3,
    required Color logoBg,
    required IconData logoIcon,
    required DateTime deadline,
  }) {
    final studentId = ref.watch(currentUserProvider).value?.uid ?? 'kofi-annan-uid';
    final bookmarkStream = ref.watch(isBookmarkedStreamProvider((studentId: studentId, opportunityId: id)));
    final isBookmarked = bookmarkStream.value ?? false;

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
                decoration: BoxDecoration(
                  color: logoBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(logoIcon, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$company • $location',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.primary,
                ),
                onPressed: () async {
                  await ref.read(bookmarkServiceProvider).toggleBookmark(studentId, id);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCardBadge(tag1, const Color(0xFFE8F4FD), Colors.blue),
              _buildCardBadge(tag2, const Color(0xFFE8F8F0), const Color(0xFF27AE60)),
              _buildCardBadge(tag3, const Color(0xFFFFF0F0), AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Deadline: ${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/student/opportunity/$id');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<OpportunityModel> _getFilteredOpportunities(List<OpportunityModel> opportunities) {
    if (_searchQuery.isEmpty) {
      return opportunities;
    }

    return opportunities.where((opp) {
      final t = opp.title.toLowerCase();
      final c = opp.company.toLowerCase();
      return t.contains(_searchQuery) || c.contains(_searchQuery);
    }).toList();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'SA';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }
}
