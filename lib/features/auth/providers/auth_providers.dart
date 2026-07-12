import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  final authService = ref.read(authServiceProvider);
  return await authService.getUserData(user.uid);
});

class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool val) => state = val;
}

final authLoadingProvider = NotifierProvider<AuthLoadingNotifier, bool>(() => AuthLoadingNotifier());

enum SignInType { student, organization }

class AuthTabNotifier extends Notifier<SignInType> {
  @override
  SignInType build() => SignInType.student;

  void setStudent() => state = SignInType.student;
  void setOrganization() => state = SignInType.organization;
}

final authTabProvider = NotifierProvider<AuthTabNotifier, SignInType>(() => AuthTabNotifier());

class PasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final passwordVisibilityProvider = NotifierProvider<PasswordVisibilityNotifier, bool>(() => PasswordVisibilityNotifier());

class ConfirmPasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final confirmPasswordVisibilityProvider = NotifierProvider<ConfirmPasswordVisibilityNotifier, bool>(() => ConfirmPasswordVisibilityNotifier());
