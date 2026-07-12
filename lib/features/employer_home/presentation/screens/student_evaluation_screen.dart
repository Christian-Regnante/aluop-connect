import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/application_service.dart';

class StudentEvaluationScreen extends ConsumerStatefulWidget {
  final String studentId;

  const StudentEvaluationScreen({super.key, required this.studentId});

  @override
  ConsumerState<StudentEvaluationScreen> createState() => _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends ConsumerState<StudentEvaluationScreen> {
  int _activeSubTab = 0; // 0: ALU Performance, 1: Resume & Portfolio, 2: Internal Notes
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic mapping based on studentId
    final name = widget.studentId == 'david-okoro'
        ? 'David Okoro'
        : widget.studentId == 'elena-rodriguez'
            ? 'Elena Rodriguez'
            : 'Amara Okafor';

    final degree = widget.studentId == 'david-okoro'
        ? 'BSc Global Challenges • Class of 2025'
        : widget.studentId == 'elena-rodriguez'
            ? 'BEng Electrical Engineering • Alumna'
            : 'BSc Computer Science • Class of 2024';

    final photoUrl = widget.studentId == 'david-okoro'
        ? 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80'
        : widget.studentId == 'elena-rodriguez'
            ? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80'
            : 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80';

    final roleTag = widget.studentId == 'david-okoro' ? 'Leader' : widget.studentId == 'elena-rodriguez' ? 'Engineer' : 'Product Manager';

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
            child: const Center(
              child: Text(
                'AO',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100.0),
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
                          // Large Avatar with verification Checkmark
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(photoUrl),
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
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Degree
                          Text(
                            degree,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pills
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPillTag(roleTag, const Color(0xFFE8F4FD), Colors.blue),
                              const SizedBox(width: 8),
                              _buildPillTag('Rwanda Campus', const Color(0xFFFFF0F0), AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Downloading Resume...')),
                                    );
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
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.border),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: const Icon(Icons.share_outlined, size: 16, color: AppColors.textPrimary),
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
                      _buildSubTab('ALU Performance', 0),
                      _buildSubTab('Resume & Portfolio', 1),
                      _buildSubTab('Internal Notes', 2),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Performance Tab Content (ALU Performance)
                if (_activeSubTab == 0) ...[
                  // Academy Metrics
                  _buildSectionCard(
                    icon: Icons.school_outlined,
                    title: 'Academy Metrics',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GPA Info Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cumulative GPA',
                                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '3.82 / 4.0',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Leadership & Attendance double columns
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  children: [
                                    Text('LEADERSHIP', style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('A+', style: TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold)),
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
                                child: const Column(
                                  children: [
                                    Text('ATTENDANCE', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('98%', style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
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
                        _buildSkillProgress('Product Strategy', 'Expert', 1.0),
                        _buildSkillProgress('SQL & Data Analysis', 'Advanced', 0.8),
                        _buildSkillProgress('Python', 'Intermediate', 0.6),
                        _buildSkillProgress('UI/UX Design', 'Advanced', 0.8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Faculty Endorsements
                  _buildSectionCard(
                    icon: Icons.check_circle_outline,
                    title: 'Faculty Endorsements',
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFDE8E8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-1.2.1&w=150&q=80'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"$name consistently demonstrated exceptional analytical skills during the Fintech Capstone. Her ability to synthesize complex user data into actionable product roadmaps is rare at the undergraduate level."',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '— Dr. Jean-Paul Kagabo, Senior Lecturer',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Project Showcase
                  _buildSectionCard(
                    icon: Icons.work_outline,
                    title: 'Projects & Contributions',
                    child: Column(
                      children: [
                        _buildProjectTile('Pan-African Micro-Lending App', 'Score: 98%', 'A high-fidelity prototype focused on financial inclusion for rural farmers in East Africa.', Icons.smartphone),
                        const Divider(color: Color(0xFFFFF0F0), height: 20),
                        _buildProjectTile('Predictive Supply Chain Model', 'Score: 94%', 'Using Python and SQL to forecast inventory needs for SME retailers in Lagos.', Icons.dns_outlined),
                      ],
                    ),
                  ),
                ] else if (_activeSubTab == 1) ...[
                  // Resume & Portfolio info stub
                  _buildSectionCard(
                    icon: Icons.link,
                    title: 'Resume & Links',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GitHub Profile:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Text('https://github.com/amaraokafor', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                        const SizedBox(height: 12),
                        const Text('LinkedIn:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Text('https://linkedin.com/in/amara-okafor', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ] else ...[
                  // Internal Notes
                  _buildSectionCard(
                    icon: Icons.lock_outline,
                    title: 'Internal Feedback',
                    badge: 'CONFIDENTIAL',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add private notes for the hiring committee...',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _feedbackController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'e.g. Candidates demonstrated strong product design execution but lacks deep frontend knowledge.',
                            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 4. Internal Feedback quick input (always visible at bottom if Performance tab is loaded)
                if (_activeSubTab == 0) ...[
                  _buildSectionCard(
                    icon: Icons.lock_outline,
                    title: 'Internal Feedback',
                    badge: 'CONFIDENTIAL',
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE8E8)),
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Add private notes for the hiring committee...',
                              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),

          // 5. Sticky Bottom Action Bar
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
                  // Reaction icons
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 20),
                  ),
                  const SizedBox(width: 6),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Icon(Icons.comment_outlined, color: AppColors.textSecondary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Reject button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        try {
                          final query = await FirebaseFirestore.instance
                              .collection('applications')
                              .where('studentId', isEqualTo: widget.studentId)
                              .get();
                          if (query.docs.isNotEmpty) {
                            final appId = query.docs.first.id;
                            await ref.read(applicationServiceProvider).updateApplicationStatus(appId, 'Closed');
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('Candidate Rejected.')),
                            );
                            navigator.pop();
                          } else {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('Application not found in database.')),
                            );
                          }
                        } catch (e) {
                          debugPrint('Error rejecting application: $e');
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
                        'Reject Candidate',
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
                  // Accept/Interview button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        try {
                          final query = await FirebaseFirestore.instance
                              .collection('applications')
                              .where('studentId', isEqualTo: widget.studentId)
                              .get();
                          if (query.docs.isNotEmpty) {
                            final appId = query.docs.first.id;
                            await ref.read(applicationServiceProvider).updateApplicationStatus(appId, 'Interview');
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('Candidate moved to Interview stage!')),
                            );
                            navigator.pop();
                          } else {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('Application not found in database.')),
                            );
                          }
                        } catch (e) {
                          debugPrint('Error moving application to interview: $e');
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
                        'Move to Interview',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildProjectTile(String title, String score, String desc, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      score,
                      style: const TextStyle(color: Color(0xFF27AE60), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.3),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.launch, size: 12, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'View Project',
                    style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
