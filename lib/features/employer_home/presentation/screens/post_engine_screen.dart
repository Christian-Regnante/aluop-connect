import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/services/opportunity_service.dart';
import '../../../../core/services/employer_service.dart';
import '../../../auth/providers/auth_providers.dart';

class PostEngineScreen extends ConsumerStatefulWidget {
  const PostEngineScreen({super.key});

  @override
  ConsumerState<PostEngineScreen> createState() => _PostEngineScreenState();
}

class _PostEngineScreenState extends ConsumerState<PostEngineScreen> {
  int _currentStep = 1; // 1, 2, or 3

  // Form Field Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _openingsController = TextEditingController();

  String _selectedType = 'Select Type';
  String _selectedDuration = 'Select Duration';
  String _selectedLocation = 'Select Location';
  String _selectedStipendType = 'Select Stipend Type';
  DateTime? _selectedDeadline;

  // Validation error states
  String? _titleError;
  String? _typeError;
  String? _durationError;
  String? _deadlineError;
  String? _locationError;
  String? _stipendError;
  String? _openingsError;
  String? _descriptionError;
  String? _requirementsError;

  final List<String> _types = ['Select Type', 'Internship', 'Micro-gig', 'Part-time', 'Full-time'];
  final List<String> _durations = ['Select Duration', '2 Weeks', '1 Month', '3 Months', '6 Months', '12 Months'];
  final List<String> _locations = ['Select Location', 'Remote', 'On-site', 'Hybrid'];
  final List<String> _stipends = ['Select Stipend Type', 'Paid', 'Unpaid'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _openingsController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep == 1) {
      setState(() {
        _titleError = null;
        _typeError = null;
        _durationError = null;
        _deadlineError = null;
      });

      bool hasError = false;
      if (_titleController.text.trim().isEmpty) {
        _titleError = 'Job Title is required';
        hasError = true;
      }
      if (_selectedType == 'Select Type') {
        _typeError = 'Please select an opportunity type';
        hasError = true;
      }
      if (_selectedDuration == 'Select Duration') {
        _durationError = 'Please select a duration';
        hasError = true;
      }
      if (_selectedDeadline == null) {
        _deadlineError = 'Please pick a deadline date and time';
        hasError = true;
      }

      if (hasError) {
        setState(() {});
        return;
      }

      setState(() {
        _currentStep = 2;
      });
    } else if (_currentStep == 2) {
      setState(() {
        _locationError = null;
        _stipendError = null;
        _openingsError = null;
      });

      bool hasError = false;
      if (_selectedLocation == 'Select Location') {
        _locationError = 'Please select a location mode';
        hasError = true;
      }
      if (_selectedStipendType == 'Select Stipend Type') {
        _stipendError = 'Please select a stipend type';
        hasError = true;
      }
      if (_openingsController.text.trim().isEmpty) {
        _openingsError = 'Please enter the number of openings';
        hasError = true;
      } else {
        final val = int.tryParse(_openingsController.text.trim());
        if (val == null || val <= 0) {
          _openingsError = 'Please enter a valid positive number';
          hasError = true;
        }
      }

      if (hasError) {
        setState(() {});
        return;
      }

      setState(() {
        _currentStep = 3;
      });
    } else {
      setState(() {
        _descriptionError = null;
        _requirementsError = null;
      });

      bool hasError = false;
      if (_descriptionController.text.trim().isEmpty) {
        _descriptionError = 'Description is required';
        hasError = true;
      }
      if (_requirementsController.text.trim().isEmpty) {
        _requirementsError = 'Please enter at least one requirement';
        hasError = true;
      }

      if (hasError) {
        setState(() {});
        return;
      }

      final user = ref.read(currentUserProvider).value;
      final employerId = user?.uid ?? 'lumen-energy-uid';

      String companyName = 'Lumen Energy';
      String industry = 'Clean Energy';
      try {
        final profile = await ref.read(employerServiceProvider).getEmployerProfile(employerId);
        if (profile != null) {
          companyName = profile.orgName;
          industry = profile.industries.isNotEmpty ? profile.industries.first : 'Clean Energy';
        }
      } catch (_) {}

      final reqs = _requirementsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final slots = int.tryParse(_openingsController.text.trim()) ?? 1;

      final opportunity = OpportunityModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employerId: employerId,
        title: _titleController.text.trim(),
        company: companyName,
        industry: industry,
        type: _selectedType,
        duration: _selectedDuration,
        locationMode: _selectedLocation,
        locationName: _selectedLocation == 'Remote' ? 'Worldwide' : 'Kigali',
        stipend: _selectedStipendType,
        openings: slots == 1 ? '1 Slot' : '$slots Slots',
        description: _descriptionController.text.trim(),
        requirements: reqs,
        tags: [industry, 'Technology'],
        postedTime: DateTime.now(),
        deadline: _selectedDeadline!,
      );

      try {
        await ref.read(opportunityServiceProvider).createOpportunity(opportunity);
      } catch (e) {
        debugPrint('Error publishing opportunity: $e');
      }

      if (mounted) {
        context.push('/employer/post-success');
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
            // 1. Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'AluOp-Connect',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDE8E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
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
                    // Title
                    const Text(
                      'Post New Opportunity',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      "Attract top talent from across the campus ecosystem by defining your project's impact.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Progress Indicator Bar
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F0),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: _currentStep / 3,
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
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Step $_currentStep of 3',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Step Container Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFDE8E8), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_currentStep == 1) _buildStep1(),
                          if (_currentStep == 2) _buildStep2(),
                          if (_currentStep == 3) _buildStep3(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // 4. Floating Bottom Action Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 1)
                    OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Publish Opportunity' : 'Continue',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && context.mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDeadline != null
            ? TimeOfDay.fromDateTime(_selectedDeadline!)
            : const TimeOfDay(hour: 23, minute: 59),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Identity',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel('Job Title'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g. Senior Research Assistant - Hea',
              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        if (_titleError != null) ...[
          const SizedBox(height: 4),
          Text(_titleError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Opportunity Type'),
        _buildDropdown(_selectedType, _types, (val) {
          setState(() {
            _selectedType = val!;
          });
        }),
        if (_typeError != null) ...[
          const SizedBox(height: 4),
          Text(_typeError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Duration'),
        _buildDropdown(_selectedDuration, _durations, (val) {
          setState(() {
            _selectedDuration = val!;
          });
        }),
        if (_durationError != null) ...[
          const SizedBox(height: 4),
          Text(_durationError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Application Deadline'),
        GestureDetector(
          onTap: () => _pickDeadline(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDeadline == null
                      ? 'Select Deadline Date & Time'
                      : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year} ${_selectedDeadline!.hour.toString().padLeft(2, '0')}:${_selectedDeadline!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: _selectedDeadline == null ? AppColors.textSecondary : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18),
              ],
            ),
          ),
        ),
        if (_deadlineError != null) ...[
          const SizedBox(height: 4),
          Text(_deadlineError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Role Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel('Location Mode'),
        _buildDropdown(_selectedLocation, _locations, (val) {
          setState(() {
            _selectedLocation = val!;
          });
        }),
        if (_locationError != null) ...[
          const SizedBox(height: 4),
          Text(_locationError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Monthly Stipend'),
        _buildDropdown(_selectedStipendType, _stipends, (val) {
          setState(() {
            _selectedStipendType = val!;
          });
        }),
        if (_stipendError != null) ...[
          const SizedBox(height: 4),
          Text(_stipendError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Available Openings'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _openingsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g. 2',
              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        if (_openingsError != null) ...[
          const SizedBox(height: 4),
          Text(_openingsError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description & Perks',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel('Description'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the main duties, goals, and daily tasks of this opportunity...',
              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        if (_descriptionError != null) ...[
          const SizedBox(height: 4),
          Text(_descriptionError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        _buildLabel('Requirements (One per line)'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _requirementsController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'e.g.\nProficiency in Python\nStrong research skills\nExcellent communicator',
              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        if (_requirementsError != null) ...[
          const SizedBox(height: 4),
          Text(_requirementsError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],
      ],
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
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: item.startsWith('Select') ? AppColors.textSecondary : AppColors.textPrimary,
                  fontSize: 14,
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
