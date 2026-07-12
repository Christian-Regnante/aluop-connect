import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/student_profile_model.dart';
import '../../../../core/services/student_service.dart';
import '../../../auth/providers/auth_providers.dart';

class StudentProfileSetupScreen extends ConsumerStatefulWidget {
  const StudentProfileSetupScreen({super.key});

  @override
  ConsumerState<StudentProfileSetupScreen> createState() => _StudentProfileSetupScreenState();
}

class _StudentProfileSetupScreenState extends ConsumerState<StudentProfileSetupScreen> {
  int _currentStep = 1; // 1, 2, or 3
  bool _hasLoadedUserInitialData = false;

  // Validation error states
  String? _fullNameError;
  String? _emailError;
  String? _phoneError;
  String? _cityError;
  String? _countryError;
  String? _languagesError;
  String? _bioError;
  String? _skillsError;
  String? _interestsError;
  String? _hubsError;

  // Step 1 Controllers & States
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final List<String> _languages = [];
  final _newLanguageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController.text = '';
    _emailController.text = '';
    _phoneCodeController.text = '+250';
    _phoneNumberController.text = '';
    _cityController.text = '';
    _countryController.text = '';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        _fullNameController.text = user.fullName;
        _emailController.text = user.email;
        final profile = await ref.read(studentServiceProvider).getStudentProfile(user.uid);
        if (profile != null) {
          setState(() {
            _phoneCodeController.text = profile.phoneCode;
            _phoneNumberController.text = profile.phoneNumber;
            _cityController.text = profile.city;
            _countryController.text = profile.country;
            _languages.clear();
            _languages.addAll(profile.languages);
            _selectedMajor = profile.major;
            _selectedGradYear = profile.expectedGradYear;
            _bioController.text = profile.bio;
            _skills.clear();
            _skills.addAll(profile.skills);
            for (var key in _opportunityInterests.keys) {
              _opportunityInterests[key] = profile.opportunityInterests.contains(key);
            }
            _selectedHubs.clear();
            _selectedHubs.addAll(profile.missionAlignmentHubs);
          });
        }
      }
    });
  }

  // Step 2 Controllers & States
  String _selectedMajor = 'BSE';
  String _selectedGradYear = '2025';
  final _bioController = TextEditingController();
  final List<String> _skills = [];
  final _newSkillController = TextEditingController();

  // Step 3 States
  final Map<String, bool> _opportunityInterests = {
    'Internship': false,
    'Research': false,
    'Part-time': false,
    'Remote': false,
  };

  final Map<String, IconData> _interestIcons = {
    'Internship': Icons.school_outlined,
    'Research': Icons.article_outlined,
    'Part-time': Icons.access_time,
    'Remote': Icons.cloud_outlined,
  };

  final List<String> _hubs = [
    'Social Innovation',
    'Conservation',
    'Infrastructure',
    'Climate Change',
    'Education',
    'Governance',
    'Urbanization',
  ];
  final Set<String> _selectedHubs = {};

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneCodeController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    _newSkillController.dispose();
    _newLanguageController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _phoneError = null;
      _cityError = null;
      _countryError = null;
      _languagesError = null;
      _bioError = null;
      _skillsError = null;
      _interestsError = null;
      _hubsError = null;
    });

    if (_currentStep == 1) {
      bool hasError = false;
      if (_fullNameController.text.trim().isEmpty) {
        _fullNameError = 'Full name is required';
        hasError = true;
      }
      if (_emailController.text.trim().isEmpty) {
        _emailError = 'University email is required';
        hasError = true;
      }
      if (_phoneNumberController.text.trim().isEmpty) {
        _phoneError = 'Phone number is required';
        hasError = true;
      }
      if (_cityController.text.trim().isEmpty) {
        _cityError = 'Current city is required';
        hasError = true;
      }
      if (_countryController.text.trim().isEmpty) {
        _countryError = 'Country is required';
        hasError = true;
      }
      if (_languages.isEmpty) {
        _languagesError = 'Please add at least one language';
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
      if (_bioController.text.trim().isEmpty) {
        _bioError = 'Professional bio is required';
        hasError = true;
      }
      if (_skills.isEmpty) {
        _skillsError = 'Please add at least one skill or interest';
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
      final oppInterests = _opportunityInterests.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      if (oppInterests.isEmpty) {
        _interestsError = 'Please select at least one opportunity interest';
        hasError = true;
      }
      if (_selectedHubs.isEmpty) {
        _hubsError = 'Please select at least one mission alignment hub';
        hasError = true;
      }
      if (hasError) {
        setState(() {});
        return;
      }

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'kofi-annan-uid';

      final studentProfile = StudentProfileModel(
        uid: uid,
        phoneCode: _phoneCodeController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        languages: _languages,
        photoUrl: '',
        major: _selectedMajor,
        expectedGradYear: _selectedGradYear,
        bio: _bioController.text.trim(),
        skills: _skills,
        opportunityInterests: oppInterests,
        missionAlignmentHubs: _selectedHubs.toList(),
        resumeUrl: 'dummy_resume.pdf',
      );

      try {
        final updatedName = _fullNameController.text.trim();
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'fullName': updatedName});

        await ref.read(studentServiceProvider).createStudentProfile(studentProfile, updatedName);
        await ref.read(authServiceProvider).completeSetup(uid);
        ref.invalidate(currentUserProvider);
      } catch (e) {
        debugPrint('Error saving student profile: $e');
      }

      if (mounted) {
        context.go('/student-home');
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
    final userAsync = ref.watch(currentUserProvider);
    userAsync.whenData((user) {
      if (user != null && !_hasLoadedUserInitialData) {
        _fullNameController.text = user.fullName;
        _emailController.text = user.email;
        _hasLoadedUserInitialData = true;
      }
    });

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

            // Scrollable Step Content
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

            // Floating Continue button
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
                        _currentStep == 3 ? Icons.rocket_launch : Icons.arrow_forward,
                        size: 16,
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
    String title = 'Build Your Profile';
    String subtitle = 'Start with the basics to begin your journey at ALU.';

    if (_currentStep == 2) {
      title = 'Craft Your Identity';
      subtitle = 'Tell us about your academic background and professional aspirations.';
    } else if (_currentStep == 3) {
      title = 'Match Your Interests';
      subtitle = 'Help us find the best opportunities tailored for you.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
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
    if (_currentStep == 2) {
      stepLabel = 'STEP 2 OF 3';
    } else if (_currentStep == 3) {
      stepLabel = 'Step 3 of 3: Preferences & Impact';
    }

    String rightLabel = '33% Completed';
    if (_currentStep == 2) {
      rightLabel = '66% Completed';
    } else if (_currentStep == 3) {
      rightLabel = '100% Complete';
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
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
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

  // STEP 1 Form
  Widget _buildStep1Form() {
    return Column(
      children: [
        // Personal Information Card
        _buildSectionCard(
          icon: Icons.person,
          title: 'Personal Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Full Name'),
              _buildInputContainer(
                child: TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter full name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_fullNameError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _fullNameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              _buildLabel('University Email'),
              _buildInputContainer(
                color: const Color(0xFFFFF0F0),
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter university email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_emailError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 6),
              const Text(
                'Verified university account',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 16),
              _buildLabel('Phone Number'),
              Row(
                children: [
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFF0F0)),
                    ),
                    child: TextField(
                      controller: _phoneCodeController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputContainer(
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number (e.g. 780 000 000)',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_phoneError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _phoneError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Location Card
        _buildSectionCard(
          icon: Icons.location_on,
          title: 'Location',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Current City'),
              _buildInputContainer(
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Enter current city (e.g. Kigali)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_cityError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _cityError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              _buildLabel('Country'),
              _buildInputContainer(
                child: TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    hintText: 'Enter country (e.g. Rwanda)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              if (_countryError != null) ...[
                const SizedBox(height: 4),
                Text(
                  _countryError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Language Proficiency Card
        _buildSectionCard(
          icon: Icons.translate,
          title: 'Language Proficiency',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_languages.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _languages.map((lang) {
                    return Chip(
                      label: Text(
                        lang,
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: const Color(0xFFFFF0F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 12, color: AppColors.primary),
                      onDeleted: () {
                        setState(() {
                          _languages.remove(lang);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFF0F0)),
                      ),
                      child: TextField(
                        controller: _newLanguageController,
                        decoration: const InputDecoration(
                          hintText: 'Add language (e.g. English)...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                    onPressed: () {
                      final val = _newLanguageController.text.trim();
                      if (val.isNotEmpty) {
                        setState(() {
                          _languages.add(val);
                          _newLanguageController.clear();
                          _languagesError = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              if (_languagesError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _languagesError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2 Form
  Widget _buildStep2Form() {
    return Column(
      children: [
        // Academic Focus Card
        _buildSectionCard(
          icon: Icons.school_outlined,
          title: 'Academic Focus',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Major / Field of Study'),
              _buildDropdown(_selectedMajor, ['BSE', 'BEL', 'IBT'], (val) {
                setState(() {
                  _selectedMajor = val!;
                });
              }),
              const SizedBox(height: 16),
              _buildLabel('Expected Graduation'),
              _buildDropdown(_selectedGradYear, ['2024', '2025', '2026', '2027'], (val) {
                setState(() {
                  _selectedGradYear = val!;
                });
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Professional Bio Card
        _buildSectionCard(
          icon: Icons.article_outlined,
          title: 'Professional Bio',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Briefly describe your impact-driven goals...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFF0F0)),
                ),
                child: TextField(
                  controller: _bioController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Enter professional bio',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              if (_bioError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _bioError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Skills & Interests Card
        _buildSectionCard(
          icon: Icons.bolt,
          title: 'Skills & Interests',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_skills.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skills.map((skill) {
                    return Chip(
                      label: Text(
                        skill,
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: const Color(0xFFFFF0F0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 12, color: AppColors.primary),
                      onDeleted: () {
                        setState(() {
                          _skills.remove(skill);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFF0F0)),
                      ),
                      child: TextField(
                        controller: _newSkillController,
                        decoration: const InputDecoration(
                          hintText: 'Add skill...',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final val = _newSkillController.text.trim();
                      if (val.isNotEmpty) {
                        setState(() {
                          _skills.add(val);
                          _newSkillController.clear();
                          _skillsError = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              if (_skillsError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _skillsError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3 Form
  Widget _buildStep3Form() {
    return Column(
      children: [
        // Opportunity Interests Card
        _buildSectionCard(
          icon: Icons.work_outline,
          title: 'Opportunity Interests',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: _opportunityInterests.keys.map((interest) {
                  final isSelected = _opportunityInterests[interest] ?? false;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _opportunityInterests[interest] = !isSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFFFF0F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _interestIcons[interest],
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            interest,
                            style: TextStyle(
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_interestsError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _interestsError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Mission Alignment Card
        _buildSectionCard(
          icon: Icons.public_outlined,
          title: 'Mission Alignment',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Which ALU Hubs are you most passionate about?',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _hubs.map((hub) {
                  final isSelected = _selectedHubs.contains(hub);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedHubs.remove(hub);
                        } else {
                          _selectedHubs.add(hub);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFFFF0F0),
                        ),
                      ),
                      child: Text(
                        hub,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_hubsError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _hubsError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Resume Card
        _buildSectionCard(
          icon: Icons.description_outlined,
          title: 'Resume',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Showcase your journey so far.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFF0F0), width: 1.5, style: BorderStyle.solid), // Styled dashed preview
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.textSecondary),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Drag & drop or ', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        Text('Browse files', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'PDF, DOCX (Max 5MB)',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
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
              if (action != null) ...[
                const Spacer(),
                action,
              ],
            ],
          ),
          const SizedBox(height: 16),
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

  Widget _buildInputContainer({required Widget child, Color color = Colors.white}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFF0F0)),
      ),
      child: child,
    );
  }

  Widget _buildDropdown(String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFF0F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
