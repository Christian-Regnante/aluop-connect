import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/models/opportunity_model.dart';
import '../widgets/home_header.dart';
import '../widgets/filter_chip_list.dart';
import '../widgets/top_match_card.dart';
import '../widgets/recommended_job_card.dart';

class StudentHomeFeed extends ConsumerStatefulWidget {
  const StudentHomeFeed({super.key});

  @override
  ConsumerState<StudentHomeFeed> createState() => _StudentHomeFeedState();
}

class _StudentHomeFeedState extends ConsumerState<StudentHomeFeed> {
  String _selectedFilter = 'All Missions';

  @override
  Widget build(BuildContext context) {
    final activeOppsAsync = ref.watch(activeOpportunitiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            Expanded(
              child: activeOppsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Error loading feed: $err')),
                data: (opportunities) {
                  final industries = opportunities
                      .map((opp) => opp.industry.trim())
                      .where((ind) => ind.isNotEmpty)
                      .toSet()
                      .toList();
                  final filters = ['All Missions', ...industries];
                  final filtered = _filterList(opportunities);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilterChipList(
                          selectedFilter: _selectedFilter,
                          onFilterChanged: (filter) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          filters: filters,
                        ),
                        const SizedBox(height: 24),
                        
                        // Top Matches Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Top Matches',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Top Matches Horizontal List
                        SizedBox(
                          height: 310,
                          child: filtered.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No opportunities found.',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filtered.length,
                                  itemBuilder: (context, idx) {
                                    final opp = filtered[idx];
                                    IconData icon = Icons.eco_outlined;
                                    if (opp.industry.toLowerCase().contains('health')) {
                                      icon = Icons.health_and_safety_outlined;
                                    } else if (opp.industry.toLowerCase().contains('energy')) {
                                      icon = Icons.solar_power_outlined;
                                    }
                                    
                                    return TopMatchCard(
                                      id: opp.id,
                                      title: opp.title,
                                      category: opp.industry,
                                      description: opp.description,
                                      imageUrl: 'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                                      details: '${opp.locationMode} • ${opp.duration}',
                                      categoryIcon: icon,
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Recommended Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Recommended for you',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Recommended Vertical List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: filtered.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Text(
                                      'No recommendations available.',
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, idx) {
                                    final opp = filtered[idx];
                                    
                                    final diff = DateTime.now().difference(opp.postedTime);
                                    String postedText = 'Posted today';
                                    if (diff.inDays > 0) {
                                      postedText = 'Posted ${diff.inDays} days ago';
                                    } else if (diff.inHours > 0) {
                                      postedText = 'Posted ${diff.inHours} hours ago';
                                    }

                                    return RecommendedJobCard(
                                      id: opp.id,
                                      title: opp.title,
                                      company: opp.company,
                                      industry: opp.industry,
                                      description: opp.description,
                                      tags: opp.tags,
                                      postedTime: '$postedText • Deadline: ${opp.deadline.day}/${opp.deadline.month}/${opp.deadline.year}',
                                      status: opp.openings,
                                      statusIcon: Icons.access_time,
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OpportunityModel> _filterList(List<OpportunityModel> opportunities) {
    if (_selectedFilter == 'All Missions') {
      return opportunities;
    }
    // Filter by industry/tags matching selected filter
    return opportunities.where((opp) {
      final text = _selectedFilter.toLowerCase();
      return opp.industry.toLowerCase().contains(text) || 
             opp.tags.any((t) => t.toLowerCase().contains(text));
    }).toList();
  }
}
