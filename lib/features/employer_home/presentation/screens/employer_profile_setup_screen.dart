import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/employer_profile_model.dart';
import '../../../../core/services/employer_service.dart';
import '../../../auth/providers/auth_providers.dart';

class EmployerProfileSetupScreen extends ConsumerStatefulWidget {
  const EmployerProfileSetupScreen({super.key});

  @override
  ConsumerState<EmployerProfileSetupScreen> createState() => _EmployerProfileSetupScreenState();
}

class _EmployerProfileSetupScreenState extends ConsumerState<EmployerProfileSetupScreen> {
  int _currentStep = 1; // 1, 2, or 3

  // Validation error states
  String? _orgNameError;
  String? _websiteError;
  String? _industriesError;
  String? _missionError;
  String? _bioError;
  String? _valuesError;
  String? _hqError;
  String? _linkedinError;
  String? _leadershipError;

  // Step 1 Controllers & States
  final _orgNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final Set<String> _selectedIndustries = {};
  final List<String> _industries = ['Technology', 'Clean Energy', 'Healthcare', 'Agriculture', 'Education'];

  @override
  void initState() {
    super.initState();
    _orgNameController.text = '';
    _websiteController.text = '';
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        final profile = await ref.read(employerServiceProvider).getEmployerProfile(user.uid);
        if (profile != null) {
          setState(() {
            _orgNameController.text = profile.orgName;
            _websiteController.text = profile.websiteUrl;
            _selectedIndustries.clear();
            _selectedIndustries.addAll(profile.industries);
            _missionController.text = profile.missionStatement;
            _bioController.text = profile.bio;
            _selectedValues.clear();
            _selectedValues.addAll(profile.coreValues);
            _hqController.text = profile.hqLocation;
            _linkedinController.text = profile.linkedinUrl;
            _members.clear();
            for (var member in profile.teamMembers) {
              _members.add({
                'name': member['name'] ?? '',
                'role': member['role'] ?? '',
                'photo': member['photoUrl'] ?? '',
              });
            }
          });
        }
      }
    });
  }

  // Step 2 Controllers & States
  final _missionController = TextEditingController();
  final _bioController = TextEditingController();
  final Set<String> _selectedValues = {};

  final List<Map<String, dynamic>> _valuesList = [
    {'name': 'Innovation', 'icon': Icons.lightbulb_outline},
    {'name': 'Sustainability', 'icon': Icons.eco_outlined},
    {'name': 'Community', 'icon': Icons.people_outline},
    {'name': 'Growth', 'icon': Icons.trending_up},
    {'name': 'Integrity', 'icon': Icons.verified_user_outlined},
    {'name': 'Agility', 'icon': Icons.speed_outlined},
  ];

  // Step 3 Controllers & States
  final _hqController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  String? _verificationError;
  
  // Leadership list starts empty
  final List<Map<String, String>> _members = [];

  bool _isAddingMember = false;
  final _memberNameController = TextEditingController();
  final _memberRoleController = TextEditingController();

  @override
  void dispose() {
    _orgNameController.dispose();
    _websiteController.dispose();
    _missionController.dispose();
    _bioController.dispose();
    _hqController.dispose();
    _linkedinController.dispose();
    _memberNameController.dispose();
    _memberRoleController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    setState(() {
      _orgNameError = null;
      _websiteError = null;
      _industriesError = null;
      _missionError = null;
      _bioError = null;
      _valuesError = null;
      _hqError = null;
      _linkedinError = null;
      _leadershipError = null;
      _verificationError = null;
    });

    if (_currentStep == 1) {
      bool hasError = false;
      if (_orgNameController.text.trim().isEmpty) {
        _orgNameError = 'Organization name is required';
        hasError = true;
      }
      if (_websiteController.text.trim().isEmpty) {
        _websiteError = 'Website URL is required';
        hasError = true;
      }
      if (_selectedIndustries.isEmpty) {
        _industriesError = 'Please select at least one industry';
        hasError = true;
      }
      if (hasError) {
        setState(() {});
        return;
      }
      setState(() {
        _currentStep++;
      });
    } else if (_currentStep == 2) {
      bool hasError = false;
      if (_missionController.text.trim().isEmpty) {
        _missionError = 'Mission statement is required';
        hasError = true;
      }
      if (_bioController.text.trim().isEmpty) {
        _bioError = 'Company bio is required';
        hasError = true;
      }
      if (_selectedValues.isEmpty) {
        _valuesError = 'Please select at least one core value';
        hasError = true;
      }
      if (hasError) {
        setState(() {});
        return;
      }
      setState(() {
        _currentStep++;
      });
    } else {
      bool hasError = false;
      if (_hqController.text.trim().isEmpty) {
        _hqError = 'Headquarters location is required';
        hasError = true;
      }
      if (_linkedinController.text.trim().isEmpty) {
        _linkedinError = 'LinkedIn URL is required';
        hasError = true;
      }
      if (_members.isEmpty) {
        _leadershipError = 'Please add at least one core leadership member';
        hasError = true;
      }
      if (_verificationCodeController.text.trim().isEmpty) {
        _verificationError = 'Verification code is required';
        hasError = true;
      }

      if (!hasError) {
        try {
          final docRef = FirebaseFirestore.instance.collection('admin_configs').doc('verification');
          final docSnap = await docRef.get();
          String correctCode = 'ALU-9283-2833';
          if (!docSnap.exists) {
            await docRef.set({'code': correctCode});
          } else {
            correctCode = docSnap.data()?['code'] ?? 'ALU-9283-2833';
          }

          if (_verificationCodeController.text.trim() != correctCode) {
            _verificationError = 'Invalid code. Please validate your startup with school authorities to get the code.';
            hasError = true;
          }
        } catch (e) {
          if (_verificationCodeController.text.trim() != 'ALU-9283-2833') {
            _verificationError = 'Invalid code. Please validate your startup with school authorities to get the code.';
            hasError = true;
          }
        }
      }

      if (hasError) {
        setState(() {});
        return;
      }

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'lumen-energy-uid';

      final team = _members.map((m) => {
        'name': m['name'] ?? '',
        'role': m['role'] ?? '',
        'photoUrl': m['photo'] ?? '',
      }).toList();

      final employerProfile = EmployerProfileModel(
        uid: uid,
        orgName: _orgNameController.text.trim(),
        logoUrl: '',
        websiteUrl: _websiteController.text.trim(),
        industries: _selectedIndustries.toList(),
        missionStatement: _missionController.text.trim(),
        bio: _bioController.text.trim(),
        coreValues: _selectedValues.toList(),
        hqLocation: _hqController.text.trim(),
        linkedinUrl: _linkedinController.text.trim(),
        teamMembers: team,
      );

      try {
        await ref.read(employerServiceProvider).createEmployerProfile(employerProfile);
        await ref.read(authServiceProvider).completeSetup(uid);
        ref.invalidate(currentUserProvider);
      } catch (e) {
        debugPrint('Error saving employer profile: $e');
      }

      if (mounted) {
        context.go('/employer-home');
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Onboarding Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    GestureDetector(
                      onTap: _prevStep,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  const Text(
                    'Onboarding',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Title and Subtitle based on active step
                    _buildStepHeaderTitle(),
                    const SizedBox(height: 24),

                    // Progress bar
                    _buildProgressBar(),
                    const SizedBox(height: 24),

                    // Cards details
                    if (_currentStep == 1) _buildStep1Form(),
                    if (_currentStep == 2) _buildStep2Form(),
                    if (_currentStep == 3) _buildStep3Form(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Continue action button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == 3 ? 'Complete Profile' : 'Continue',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentStep == 3 ? Icons.edit_note : Icons.arrow_forward,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeaderTitle() {
    String title = 'Build your organization profile';
    String subtitle = 'Tell us the fundamental details about your startup to begin connecting with top academic talent and industry partners.';

    if (_currentStep == 2) {
      title = 'Our Identity';
      subtitle = 'Tell us about your organization\'s mission, vision, and workplace culture.';
    } else if (_currentStep == 3) {
      title = 'Team & Presence';
      subtitle = 'Finalize your professional identity by defining your base and core leadership team.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    double progress = _currentStep / 3;
    String stepLabel = 'Step 1 of 3';
    String rightLabel = 'Organization Basics';

    if (_currentStep == 2) {
      stepLabel = 'STEP 2 OF 3';
      rightLabel = 'Mission & Culture';
    } else if (_currentStep == 3) {
      stepLabel = 'STEP 3 OF 3';
      rightLabel = 'FINAL STAGE';
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stepLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              rightLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 1 Basics
  Widget _buildStep1Form() {
    return Column(
      children: [
        // Basics Fields Card
        _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Organization Name'),
              _buildInputContainer(
                child: TextField(
                  controller: _orgNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter organization name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_orgNameError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _orgNameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              _buildLabel('Website URL'),
              _buildInputContainer(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: const Text('https://', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _websiteController,
                        decoration: const InputDecoration(
                          hintText: 'www.yourstartup.com',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_websiteError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _websiteError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              _buildLabel('Industries'),
              const Text(
                'Select the sectors that your organization falls in.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _industries.map((ind) {
                  final isSelected = _selectedIndustries.contains(ind);
                  return FilterChip(
                    label: Text(ind),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedIndustries.add(ind);
                        } else {
                          _selectedIndustries.remove(ind);
                        }
                        if (_selectedIndustries.isNotEmpty) {
                          _industriesError = null;
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_industriesError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _industriesError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2 Mission & Culture
  Widget _buildStep2Form() {
    return Column(
      children: [
        // Our Identity Card
        _buildSectionCard(
          title: 'Our Identity',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Mission Statement'),
              _buildInputContainer(
                child: TextField(
                  controller: _missionController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Accelerating the world\'s transition',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_missionError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _missionError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              _buildLabel('Company Bio'),
              _buildInputContainer(
                child: TextField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Tell us the story behind your startup...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              if (_bioError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _bioError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Core Values Card
        _buildSectionCard(
          title: 'Core Values',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select the pillars that define your workplace culture.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _valuesList.map((val) {
                  final isSelected = _selectedValues.contains(val['name']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedValues.remove(val['name']);
                        } else {
                          _selectedValues.add(val['name'] as String);
                        }
                        if (_selectedValues.isNotEmpty) {
                          _valuesError = null;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFF0F0) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFFFF0F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(val['icon'] as IconData, size: 14, color: AppColors.textPrimary),
                          const SizedBox(width: 6),
                          Text(
                            val['name'] as String,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_valuesError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _valuesError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3 Team & Presence
  Widget _buildStep3Form() {
    return Column(
      children: [
        // Headquarters Card
        _buildSectionCard(
          title: 'Headquarters',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Location Name'),
              _buildInputContainer(
                child: TextField(
                  controller: _hqController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Kigali, Rwanda',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_hqError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _hqError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Social Network Card
        _buildSectionCard(
          title: 'Social Network',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('LinkedIn Profile URL'),
              _buildInputContainer(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Icon(Icons.link, color: AppColors.textSecondary, size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _linkedinController,
                        decoration: const InputDecoration(
                          hintText: 'linkedin.com/company/startup',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_linkedinError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _linkedinError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Core Leadership Card
        _buildSectionCard(
          title: 'Core Leadership',
          action: GestureDetector(
            onTap: () {
              setState(() {
                _isAddingMember = !_isAddingMember;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                const Text(
                  'Add Member',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              if (_leadershipError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    _leadershipError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
              // Members list
              ..._members.map((member) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFF0F0)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(member['photo']!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              member['role']!,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _members.remove(member);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),

              // Add Member form box
              if (_isAddingMember) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFF0F0), width: 1.5, style: BorderStyle.solid), // Dash outline
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF0F0),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _buildInputContainer(
                                  child: TextField(
                                    controller: _memberNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Full Name',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInputContainer(
                                  child: TextField(
                                    controller: _memberRoleController,
                                    decoration: const InputDecoration(
                                      hintText: 'Role (e.g. CTO)',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isAddingMember = false;
                                _memberNameController.clear();
                                _memberRoleController.clear();
                              });
                            },
                            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final name = _memberNameController.text.trim();
                              final role = _memberRoleController.text.trim();
                              if (name.isNotEmpty && role.isNotEmpty) {
                                setState(() {
                                  _members.add({
                                    'name': name,
                                    'role': role,
                                    'photo': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                                  });
                                  _memberNameController.clear();
                                  _memberRoleController.clear();
                                  _isAddingMember = false;
                                  _leadershipError = null;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Save Member'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Organization Verification Card
        _buildSectionCard(
          title: 'Organization Verification',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Verification Code'),
              const Text(
                'Enter the verification code provided by the ALU Administration to verify your organization.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              _buildInputContainer(
                child: TextField(
                  controller: _verificationCodeController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. ALU-9283-2833',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_verificationError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _verificationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Footer disclaimer Text
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'By completing your profile, you agree to our Marketplace Professional Standards and Community Guidelines. You can update these details anytime in settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    String? title,
    Widget? action,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFF0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (action != null) ...[
                  const Spacer(),
                  action,
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFF0F0)),
      ),
      child: child,
    );
  }
}
