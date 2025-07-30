import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/user_model.dart';
import '../domain/services/auth_service.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user data provider
final currentUserDataProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final authService = ref.watch(authServiceProvider);
  
  return authState.when(
    data: (user) {
      if (user != null) {
        return authService.getUserDataStream(user.uid);
      }
      return Stream.value(null);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Authentication controller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AuthState.initial());

  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = const AuthState.loading();
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      state = const AuthState.success();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      state = const AuthState.success();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authService.signOut();
      state = const AuthState.success();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _authService.resetPassword(email);
      state = const AuthState.success();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Clear state
  void clearState() {
    state = const AuthState.initial();
  }
}

// Auth state classes
abstract class AuthState {
  const AuthState();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.success() = _Success;
  const factory AuthState.error(String message) = _Error;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() success,
    required T Function(String message) error,
  }) {
    if (this is _Initial) return initial();
    if (this is _Loading) return loading();
    if (this is _Success) return success();
    if (this is _Error) return error((this as _Error).message);
    throw Exception('Unknown state');
  }
}

class _Initial extends AuthState {
  const _Initial();
}

class _Loading extends AuthState {
  const _Loading();
}

class _Success extends AuthState {
  const _Success();
}

class _Error extends AuthState {
  final String message;
  const _Error(this.message);
}
