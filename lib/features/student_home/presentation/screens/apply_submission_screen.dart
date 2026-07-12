import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/application_model.dart';
import '../../../../core/services/application_service.dart';
import '../../../auth/providers/auth_providers.dart';

class ApplySubmissionScreen extends ConsumerStatefulWidget {
  final String id;

  const ApplySubmissionScreen({super.key, required this.id});

  @override
  ConsumerState<ApplySubmissionScreen> createState() => _ApplySubmissionScreenState();
}

class _ApplySubmissionScreenState extends ConsumerState<ApplySubmissionScreen> {
  final _fitController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _docsController = TextEditingController();
  int _charCount = 0;

  String? _fitError;
  String? _portfolioError;

  @override
  void initState() {
    super.initState();
    _fitController.addListener(() {
      setState(() {
        _charCount = _fitController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _fitController.dispose();
    _portfolioController.dispose();
    _docsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.id == 'supply-chain-intern'
        ? 'Supply Chain Intern'
        : widget.id == 'ui-ux-designer'
            ? 'UI/UX Designer'
            : widget.id == 'data-analyst-assistant'
                ? 'Data Analyst Assistant'
                : 'Solar Grid Optimizer';

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
          'Apply for $title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Opportunity Details Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, color: AppColors.primary, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Opportunity Details',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.id == 'ui-ux-designer'
                        ? 'Join our Creative Design Hub as a UI/UX Designer. You will lead user research, visual systems, and create high-fidelity prototype flows.'
                        : 'Join the Energy Innovation Lab as a Solar Grid Optimizer. You will lead the development of algorithmic solutions for decentralized microgrids.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMiniBadge('Active', const Color(0xFFE8F8F0), const Color(0xFF27AE60)),
                      const SizedBox(width: 8),
                      _buildMiniBadge('Technical', const Color(0xFFE8F4FD), Colors.blue),
                      const SizedBox(width: 8),
                      _buildMiniBadge('Remote', const Color(0xFFE0F7FA), Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Tips Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0E6E6), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AluOp-Connect Tips',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.id == 'ui-ux-designer'
                              ? 'Showcase case studies. Mention projects where you executed user research and resolved interface layout problems.'
                              : 'Quantify your achievements. Mention specific projects where you optimized load distribution or worked with IoT hardware.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Why are you a good fit?
            const Text(
              'Why are you a good fit?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _fitController,
                    maxLines: 6,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: widget.id == 'ui-ux-designer'
                          ? 'Tell us about your experience designing interfaces, wireframes, style libraries, or previous design leadership...'
                          : 'Tell us about your experience with renewable energy systems, Python optimization libraries, or previous project leadership...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_charCount / 1000',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (_fitError != null) ...[
              const SizedBox(height: 4),
              Text(_fitError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 24),

            // 4. Portfolio/GitHub Link
            const Text(
              'Portfolio/GitHub Link',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
              ),
              child: TextField(
                controller: _portfolioController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.link, color: AppColors.textSecondary),
                  hintText: 'Add links to your projects, works, website, or your portfolio',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            if (_portfolioError != null) ...[
              const SizedBox(height: 4),
              Text(_portfolioError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 24),

            // 5. Supporting Documents Input
            const Text(
              'Supporting Documents Links (Comma-separated)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
              ),
              child: TextField(
                controller: _docsController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.description_outlined, color: AppColors.textSecondary),
                  hintText: 'e.g. https://drive.google.com/..., https://dropbox.com/...',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 6. Security Disclaimer
            const Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF27AE60)),
                SizedBox(width: 6),
                Text(
                  'Your data is stored securely in the ALU ecosystem.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 7. Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _fitError = null;
                    _portfolioError = null;
                  });

                  bool hasError = false;
                  if (_fitController.text.trim().isEmpty) {
                    _fitError = 'Please tell us why you are a good fit';
                    hasError = true;
                  }
                  if (_portfolioController.text.trim().isEmpty) {
                    _portfolioError = 'Please enter your projects or portfolio link';
                    hasError = true;
                  }

                  if (hasError) {
                    setState(() {});
                    return;
                  }

                  final user = ref.read(currentUserProvider).value;
                  final studentId = user?.uid ?? 'kofi-annan-uid';

                  final application = ApplicationModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    opportunityId: widget.id,
                    studentId: studentId,
                    coverLetter: _fitController.text.trim(),
                    portfolioUrl: _portfolioController.text.trim(),
                    resumeUrl: _docsController.text.trim().isEmpty ? 'no_additional_docs' : _docsController.text.trim(),
                    status: 'Applied',
                    appliedAt: DateTime.now(),
                  );

                  final router = GoRouter.of(context);
                  try {
                    await ref.read(applicationServiceProvider).createApplication(application);
                    router.push('/student/apply-success');
                  } catch (e) {
                    debugPrint('Error submitting application: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Application',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
}
