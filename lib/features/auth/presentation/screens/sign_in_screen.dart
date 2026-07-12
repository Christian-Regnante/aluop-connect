import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_tab_switch.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_sign_in_button.dart';
import '../../providers/auth_providers.dart';
import '../../../../core/theme/app_colors.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      ref.read(authLoadingProvider.notifier).setLoading(true);
      final userCred = await ref.read(authServiceProvider).signInWithEmail(email, password);
      final userModel = await ref.read(authServiceProvider).getUserData(userCred.user!.uid);
      
      if (mounted) {
        if (userModel != null) {
          if (userModel.role == 'student') {
            if (userModel.hasCompletedSetup) {
              context.go('/student-home');
            } else {
              context.go('/student/profile-setup');
            }
          } else {
            if (userModel.hasCompletedSetup) {
              context.go('/employer-home');
            } else {
              context.go('/employer/profile-setup');
            }
          }
        } else {
          // Fallback if user model doesn't exist for some reason
          final isStudent = ref.read(authTabProvider) == SignInType.student;
          if (isStudent) {
            context.go('/student/profile-setup');
          } else {
            context.go('/employer/profile-setup');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: ${e.toString()}')),
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
                        child: const Icon(Icons.school, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your ALU professional\necosystem',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Tab Switch
                      const AuthTabSwitch(),
                      const SizedBox(height: 32),

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
                        topTrailingWidget: GestureDetector(
                          onTap: () {
                            // Handle forgot password
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppColors.redLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                      const SizedBox(height: 32),

                      // Sign In Button
                      isLoading 
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Sign In',
                            icon: Icons.arrow_forward,
                            onPressed: _handleSignIn,
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

                      // Google Sign In Button
                      SocialSignInButton(
                        onPressed: () async {
                          try {
                            ref.read(authLoadingProvider.notifier).setLoading(true);
                            final originSection = isStudent ? 'student' : 'employer';
                            final userCred = await ref.read(authServiceProvider).signInWithGoogle(originSection);
                            if (userCred != null) {
                              final userModel = await ref.read(authServiceProvider).getUserData(userCred.user!.uid);
                              if (context.mounted) {
                                if (userModel != null) {
                                  if (userModel.role == 'student') {
                                    if (userModel.hasCompletedSetup) {
                                      context.go('/student-home');
                                    } else {
                                      context.go('/student/profile-setup');
                                    }
                                  } else {
                                    if (userModel.hasCompletedSetup) {
                                      context.go('/employer-home');
                                    } else {
                                      context.go('/employer/profile-setup');
                                    }
                                  }
                                } else {
                                  if (isStudent) {
                                    context.go('/student/profile-setup');
                                  } else {
                                    context.go('/employer/profile-setup');
                                  }
                                }
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

                      // Create Account
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'New to the hub? ',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/auth/sign-up');
                            },
                            child: const Text(
                              'Create an account',
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

class DotsBackground extends StatelessWidget {
  final Widget child;

  const DotsBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DotsPainter(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const radius = 1.5;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
