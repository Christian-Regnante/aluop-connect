import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_tab_switch.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_sign_in_button.dart';
import '../../providers/auth_providers.dart';
import '../../../../core/theme/app_colors.dart';
import 'sign_in_screen.dart'; // To access DotsBackground

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final fullName = _fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    final selectedTab = ref.read(authTabProvider);
    final originSection = selectedTab == SignInType.student ? 'student' : 'employer';

    try {
      ref.read(authLoadingProvider.notifier).setLoading(true);
      await ref.read(authServiceProvider).signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        originSection: originSection,
      );
      if (mounted) {
        context.go('/auth/sign-in');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully. Please sign in.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        ref.read(authLoadingProvider.notifier).setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(passwordVisibilityProvider);
    final obscureConfirmPassword = ref.watch(confirmPasswordVisibilityProvider);
    final selectedTab = ref.watch(authTabProvider);
    final isLoading = ref.watch(authLoadingProvider);
    
    final isStudent = selectedTab == SignInType.student;
    final emailHint = isStudent ? 'name@alustudent.com' : 'name@alueducation.com';
    final emailHelper = isStudent 
        ? '* Use your @alustudent.com domain' 
        : '* Use @alueducation.com or @alustudent.com';

    return Scaffold(
      body: DotsBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'AluOp-Connect',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ),
                    ),
                    const Icon(Icons.help_outline, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Main Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Icon and Welcome Text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join the ALU professional ecosystem',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Tab Switch
                      const AuthTabSwitch(),
                      const SizedBox(height: 32),

                      // Full Name Field
                      CustomTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        hint: 'John Doe',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        label: 'Institutional Email',
                        hint: emailHint,
                        prefixIcon: Icons.email_outlined,
                        helperText: emailHelper,
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            ref.read(passwordVisibilityProvider.notifier).toggle();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            ref.read(confirmPasswordVisibilityProvider.notifier).toggle();
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Create Account Button
                      isLoading 
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Create Account',
                            icon: Icons.check_circle_outline,
                            onPressed: _handleSignUp,
                          ),
                      const SizedBox(height: 8),

                      // OR Divider
                      const Center(
                        child: Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Google Sign Up Button
                      SocialSignInButton(
                        onPressed: () async {
                          try {
                            ref.read(authLoadingProvider.notifier).setLoading(true);
                            final originSection = isStudent ? 'student' : 'employer';
                            final userCred = await ref.read(authServiceProvider).signInWithGoogle(originSection);
                            if (userCred != null && context.mounted) {
                              if (isStudent) {
                                context.go('/student-home');
                              } else {
                                context.go('/employer-home');
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sign in failed: ${e.toString()}')),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              ref.read(authLoadingProvider.notifier).setLoading(false);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 32),

                      const Divider(color: AppColors.border),
                      const SizedBox(height: 24),

                      // Sign In Link
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/auth/sign-in');
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Footer
                Text(
                  '© 2024 ALUOP Connect. All Rights Reserved.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
