import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/application_service.dart';
import '../../../../core/services/student_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/application_model.dart';
import '../../../auth/providers/auth_providers.dart';

final studentUserProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  return await ref.read(authServiceProvider).getUserData(uid);
});

class StudentEvaluationScreen extends ConsumerStatefulWidget {
  final String studentId;

  const StudentEvaluationScreen({super.key, required this.studentId});

  @override
  ConsumerState<StudentEvaluationScreen> createState() => _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends ConsumerState<StudentEvaluationScreen> {
  int _activeSubTab = 0; // 0: Profile View, 1: Application Details, 2: Internal Notes
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentUserAsync = ref.watch(studentUserProvider(widget.studentId));
    final studentProfileAsync = ref.watch(studentProfileStreamProvider(widget.studentId));
    final employer = ref.watch(currentUserProvider).value;
    final employerId = employer?.uid ?? 'lumen-energy-uid';
    final employerAppsAsync = ref.watch(employerApplicationsProvider(employerId));

    // Extract currentApp reactively to use in bottomNavigationBar
    final currentApp = employerAppsAsync.value?.firstWhere(
      (app) => app.studentId == widget.studentId,
      orElse: () => ApplicationModel(
        id: '',
        opportunityId: '',
        studentId: widget.studentId,
        coverLetter: 'No fit statement provided.',
        portfolioUrl: '',
        resumeUrl: '',
        status: 'Applied',
        appliedAt: DateTime.now(),
      ),
    );

    // Setup sticky bottom navigation bar actions
    final bottomBar = currentApp == null || currentApp.id.isEmpty
        ? null
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            child: Row(
              children: [
                // Reject button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      try {
                        await ref.read(applicationServiceProvider).updateApplicationStatus(currentApp.id, 'Closed');
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Candidate Rejected.')),
                        );
                        navigator.pop();
                      } catch (e) {
                        debugPrint('Error rejecting application: $e');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Reject',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Interview button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      try {
                        await ref.read(applicationServiceProvider).updateApplicationStatus(currentApp.id, 'Interview');
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Candidate moved to Interview stage!')),
                        );
                        navigator.pop();
                      } catch (e) {
                        debugPrint('Error moving application to interview: $e');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Interview',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Accept button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      try {
                        await ref.read(applicationServiceProvider).updateApplicationStatus(currentApp.id, 'Accepted');
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Candidate Accepted successfully!')),
                        );
                        navigator.pop();
                      } catch (e) {
                        debugPrint('Error accepting application: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Accept',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

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
          'AluOp-Connect',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                employer != null ? _getInitials(employer.fullName) : 'AO',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar,
      body: studentUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading student: $err')),
        data: (studentUser) {
          if (studentUser == null) {
            return const Center(child: Text('Student user record not found.'));
          }

          return studentProfileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, stack) => Center(child: Text('Error loading student profile: $err')),
            data: (profile) {
              if (profile == null) {
                return const Center(child: Text('Student profile not found.'));
              }

              return employerAppsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('Error loading applications: $err')),
                data: (employerApps) {
                  final activeApp = employerApps.firstWhere(
                    (app) => app.studentId == widget.studentId,
                    orElse: () => ApplicationModel(
                      id: '',
                      opportunityId: '',
                      studentId: widget.studentId,
                      coverLetter: 'No fit statement provided.',
                      portfolioUrl: '',
                      resumeUrl: '',
                      status: 'Applied',
                      appliedAt: DateTime.now(),
                    ),
                  );

                  // Setup notes controller text
                  if (_feedbackController.text.isEmpty && activeApp.internalNotes.isNotEmpty) {
                    _feedbackController.text = activeApp.internalNotes;
                  }

                  final initials = _getInitials(studentUser.fullName);
                  final locationText = '${profile.city}, ${profile.country}';

                  // Map major full details
                  String majorDetails = profile.major;
                  if (profile.major.toUpperCase() == 'BSE') {
                    majorDetails = 'BSc (Hons) in Software Engineering';
                  } else if (profile.major.toUpperCase() == 'BEL') {
                    majorDetails = 'BSc (Hons) in Entrepreneurial Leadership';
                  } else if (profile.major.toUpperCase() == 'IBT') {
                    majorDetails = 'BSc (Hons) in International Business and Trade (IBT)';
                  }

                  final degreeText = '$majorDetails • Class of ${profile.expectedGradYear}';

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Profile Header Card
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.primary, Color(0xFFFDF8F8)],
                              stops: [0.35, 0.35],
                                ),
                          ),
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Large Initials Avatar
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF0F0),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.primary, width: 2.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            initials,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        right: 2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF27AE60),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                          child: const Text(
                                            'ACTIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Name
                                  Text(
                                    studentUser.fullName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Degree / Major Info
                                  Text(
                                    degreeText,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  // Location representation tag
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        locationText,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Download Resume link row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () async {
                                            final links = activeApp.resumeUrl
                                                .split(',')
                                                .map((e) => e.trim())
                                                .where((e) => e.isNotEmpty)
                                                .toList();
                                            if (links.isNotEmpty) {
                                              final uri = Uri.parse(links.first);
                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Could not launch ${links.first}')),
                                                  );
                                                }
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('No resume link submitted.')),
                                              );
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: AppColors.border),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          icon: const Icon(Icons.download, size: 14, color: AppColors.textPrimary),
                                          label: const Text(
                                            'Download Resume',
                                            style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 2. Sub-tabs bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSubTab('Profile View', 0),
                              _buildSubTab('Application Details', 1),
                              _buildSubTab('Internal Notes', 2),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3. Tab Contents
                        if (_activeSubTab == 0) ...[
                          // Academy Metrics
                          _buildSectionCard(
                            icon: Icons.school_outlined,
                            title: 'Academy Metrics',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF6F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Cumulative GPA',
                                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${profile.gpa.toStringAsFixed(2)} / 4.0',
                                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0F2F1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            const Text('LEADERSHIP', style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(profile.leadershipGrade, style: const TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F4FD),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            const Text('ATTENDANCE', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text('${profile.attendancePercentage.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Technical Matrix
                          _buildSectionCard(
                            icon: Icons.grid_view_outlined,
                            title: 'Technical Matrix',
                            child: Column(
                              children: [
                                if (profile.skills.isEmpty && profile.languages.isEmpty)
                                  const Center(
                                    child: Text(
                                      'No skills or languages listed.',
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                  ),
                                ...profile.skills.map((skill) => _buildSkillProgress(skill, 'Technical Skill', 0.85)),
                                ...profile.languages.map((lang) => _buildSkillProgress(lang, 'Language', 0.90)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Mission Alignment Hubs
                          _buildSectionCard(
                            icon: Icons.check_circle_outline,
                            title: 'Mission Alignment Hubs',
                            child: profile.missionAlignmentHubs.isEmpty
                                ? const Text('No mission alignment hubs selected.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: profile.missionAlignmentHubs.map((hub) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF0F0),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFFFD5D5), width: 1),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.hub_outlined, color: AppColors.primary, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            hub,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Opportunity Interests
                          _buildSectionCard(
                            icon: Icons.work_outline,
                            title: 'Opportunity Interests',
                            child: profile.opportunityInterests.isEmpty
                                ? const Text('No interests selected.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: profile.opportunityInterests.map((interest) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F4FD),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFC2E2FB), width: 1),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star_border, color: Colors.blue, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            interest,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                          ),
                        ] else if (_activeSubTab == 1) ...[
                          // Application Details
                          _buildSectionCard(
                            icon: Icons.assignment_outlined,
                            title: 'Application Details',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fit & Motivation Statement:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF6F6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFFDE8E8)),
                                  ),
                                  child: Text(
                                    activeApp.coverLetter.trim().isEmpty ? 'No statement provided.' : activeApp.coverLetter,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Projects/Portfolio Links:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                ..._buildPortfolioLinksList(activeApp.portfolioUrl),
                                const SizedBox(height: 16),
                                const Text(
                                  'Supporting Documents Links:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                ..._buildDocumentsList(activeApp.resumeUrl),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Internal Notes
                          _buildSectionCard(
                            icon: Icons.lock_outline,
                            title: 'Internal Notes',
                            badge: 'CONFIDENTIAL',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Add private notes for the hiring committee:',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _feedbackController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Candidate demonstrated strong skillsets but lacks deep frontend knowledge.',
                                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                  onChanged: (val) async {
                                    if (activeApp.id.isNotEmpty) {
                                      await ref.read(applicationServiceProvider).updateApplicationNotes(activeApp.id, val.trim());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildPortfolioLinksList(String portfolioUrl) {
    if (portfolioUrl.trim().isEmpty) {
      return [const Text('No projects link submitted.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))];
    }
    final links = portfolioUrl.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (links.isEmpty) {
      return [const Text('No projects link submitted.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))];
    }
    return links.map((link) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(link);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: Row(
            children: [
              const Icon(Icons.launch, size: 14, color: Colors.blue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  link,
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildDocumentsList(String resumeUrl) {
    if (resumeUrl.trim().isEmpty) {
      return [const Text('No supporting documents submitted.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))];
    }
    final links = resumeUrl.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (links.isEmpty) {
      return [const Text('No supporting documents submitted.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))];
    }
    return links.map((link) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(link);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file_outlined, size: 14, color: Colors.blue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  link,
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSubTab(String label, int index) {
    final isSelected = _activeSubTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSubTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 32,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    String? badge,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE8E8)),
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
                  fontSize: 15,
                ),
              ),
              if (badge != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSkillProgress(String name, String level, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                level,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFFFF0F0),
            color: AppColors.primary,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}

String _getInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.isEmpty) return 'SA';
  if (words.length == 1) {
    return words[0].length >= 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
  }
  return '${words[0][0]}${words[1][0]}'.toUpperCase();
}
