import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/employer_service.dart';
import '../../../auth/providers/auth_providers.dart';

class EmployerProfileScreen extends ConsumerWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, stackTrace) => Center(child: Text('Error loading profile: $error')),
          data: (user) {
            final uid = user?.uid ?? 'lumen-energy-uid';
            final profileAsync = ref.watch(employerProfileStreamProvider(uid));

            return profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (profile) {
                final orgName = profile?.orgName ?? user?.fullName ?? 'Lumen-Energy';
                final website = profile?.websiteUrl ?? 'www.lumenenergy.com';
                final linkedin = profile?.linkedinUrl ?? 'linkedin.com/company/lumen-energy';
                final hq = profile?.hqLocation ?? 'Nairobi, Kenya';
                final industriesList = profile?.industries ?? ['Clean Energy'];
                final industryText = industriesList.join(', ');
                final bio = profile?.bio ?? 'No bio set yet.';
                final mission = profile?.missionStatement ?? 'No mission statement set yet.';
                final values = profile?.coreValues ?? ['Innovation', 'Sustainability'];
                final team = profile?.teamMembers ?? [];

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny_outlined,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
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
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(orgName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. Organization Info Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Organization Logo
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getInitials(orgName),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // Edit Profile Button instead of Follow
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push('/employer/profile-setup');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit, size: 14),
                                  label: const Text('Edit Profile'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Company Name
                            Text(
                              orgName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            // Verification Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F8F0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF27AE60),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified Partner',
                                    style: TextStyle(
                                      color: Color(0xFF27AE60),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Location & Sector
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '$hq • $industryText Sectors',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Website & Socials
                            Row(
                              children: [
                                _buildSocialLink(
                                  icon: Icons.language,
                                  label: 'Website',
                                  url: website,
                                ),
                                const SizedBox(width: 16),
                                _buildSocialLink(
                                  icon: Icons.link,
                                  label: 'LinkedIn',
                                  url: linkedin,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 3. Our Mission Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF0E6E6), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Our Mission',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              mission,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                    fontSize: 13,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              bio,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Tags row
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: values.map((val) => _buildMissionTag('#$val')).toList(),
                            )
                          ],
                        ),
                      ),

                      // 4. Stats Summary Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF031A33),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _buildDarkStatRow('HQ Location', hq),
                            const Divider(color: Color(0xFF1E354F), height: 24),
                            _buildDarkStatRow('Industry Group', industryText),
                            const Divider(color: Color(0xFF1E354F), height: 24),
                            _buildDarkStatRow('Partner Rating', '5.0 ★', isRating: true),
                            const SizedBox(height: 20),
                            // Download Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Downloading Impact Report...')),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Download Impact Report',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 5. Leadership & Team Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Text(
                          'Leadership & Team',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 20,
                              ),
                        ),
                      ),

                      // Team Card list
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF0E6E6), width: 1),
                        ),
                        child: team.isEmpty
                            ? const Center(
                                child: Text(
                                  'No leadership team members registered.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              )
                            : Column(
                                children: List.generate(team.length, (index) {
                                  final member = team[index];
                                  return Column(
                                    children: [
                                      _buildTeamMemberTile(
                                        name: member['name'] ?? '',
                                        role: member['role'] ?? '',
                                        imageUrl: member['photoUrl']?.isNotEmpty == true
                                            ? member['photoUrl']!
                                            : 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                                      ),
                                      if (index < team.length - 1)
                                        const Divider(color: Color(0xFFF5EEEE), height: 24),
                                    ],
                                  );
                                }),
                              ),
                      ),

                      // Logout Action Option
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: InkWell(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ref.read(authServiceProvider).signOut();
                              if (context.mounted) {
                                context.go('/auth/sign-in');
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFFD5D5), width: 1),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: AppColors.primary),
                                SizedBox(width: 12),
                                Text(
                                  'Logout from Portal',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialLink({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].length >= 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  Widget _buildMissionTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDarkStatRow(String label, String value, {bool isRating = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isRating ? const Color(0xFFFFD700) : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberTile({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                role,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
