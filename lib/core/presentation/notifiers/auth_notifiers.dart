import 'package:riverpod/riverpod.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signin_usecase.dart';


class AuthState {
  final bool isLoading;
  final AuthUserModel? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthUserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.isLoading == isLoading &&
        other.user == user &&
        other.error == error;
  }

  @override
  int get hashCode => isLoading.hashCode ^ user.hashCode ^ error.hashCode;

  @override
  String toString() => 'AuthState(isLoading: $isLoading, user: $user, error: $error)';
}

class AuthNotifiers extends StateNotifier<AuthState> {
  final SigninUsecase signinUsecase;

  AuthNotifiers(this.signinUsecase) : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    // Clear any previous error and set loading to true
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Call the use case
      final user = await signinUsecase.call(email, password);
      
      // Update state with success
      state = state.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Call sign out use case if you have one
      // await signoutUsecase.call();
      
      // Clear user data
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  String _getErrorMessage(dynamic error) {
    // You can customize error messages based on error types
    if (error.toString().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('unauthorized') || 
               error.toString().contains('401')) {
      return 'Invalid email or password. Please try again.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('server') || 
               error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    }
    
    // Default error message
    return error.toString();
  }
}
