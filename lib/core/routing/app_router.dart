import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/student_home/presentation/screens/student_main_scaffold.dart';
import '../../features/employer_home/presentation/screens/employer_main_scaffold.dart';
import '../../features/student_home/presentation/screens/opportunity_details_screen.dart';
import '../../features/student_home/presentation/screens/apply_submission_screen.dart';
import '../../features/student_home/presentation/screens/apply_success_screen.dart';
import '../../features/employer_home/presentation/screens/student_evaluation_screen.dart';
import '../../features/employer_home/presentation/screens/post_success_screen.dart';
import '../../features/student_home/presentation/screens/student_profile_setup_screen.dart';
import '../../features/employer_home/presentation/screens/employer_profile_setup_screen.dart';
import '../../features/student_home/presentation/screens/employer_detail_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/auth/sign-in',
  routes: [
    GoRoute(
      path: '/auth/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/auth/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/student-home',
      builder: (context, state) => const StudentMainScaffold(),
    ),
    GoRoute(
      path: '/employer-home',
      builder: (context, state) => const EmployerMainScaffold(),
    ),
    GoRoute(
      path: '/student/opportunity/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'solar-grid-optimizer';
        return OpportunityDetailsScreen(id: id);
      },
    ),
    GoRoute(
      path: '/student/apply/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'solar-grid-optimizer';
        return ApplySubmissionScreen(id: id);
      },
    ),
    GoRoute(
      path: '/student/apply-success',
      builder: (context, state) => const ApplySuccessScreen(),
    ),
    GoRoute(
      path: '/employer/evaluation/:studentId',
      builder: (context, state) {
        final studentId = state.pathParameters['studentId'] ?? 'amara-okafor';
        return StudentEvaluationScreen(studentId: studentId);
      },
    ),
    GoRoute(
      path: '/employer/post-success',
      builder: (context, state) => const PostSuccessScreen(),
    ),
    GoRoute(
      path: '/student/profile-setup',
      builder: (context, state) => const StudentProfileSetupScreen(),
    ),
    GoRoute(
      path: '/employer/profile-setup',
      builder: (context, state) => const EmployerProfileSetupScreen(),
    ),
    GoRoute(
      path: '/student/employer/:employerId',
      builder: (context, state) {
        final employerId = state.pathParameters['employerId'] ?? 'lumen-energy-uid';
        return EmployerDetailProfileScreen(employerId: employerId);
      },
    ),
  ],
);
