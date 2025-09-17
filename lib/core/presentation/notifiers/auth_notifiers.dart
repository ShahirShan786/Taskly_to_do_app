import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/domain/usecases/google_sign_in_usecase.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signin_usecase.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signup_usecase.dart';

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
  String toString() =>
      'AuthState(isLoading: $isLoading, user: $user, error: $error)';
}

class AuthNotifiers extends StateNotifier<AuthState> {
  final SigninUsecase signinUsecase;
  final SignupUsecase signupUsecase;
  final GoogleSignInUsecase googleSignInUsecase;

  AuthNotifiers(this.signinUsecase, this.signupUsecase , this.googleSignInUsecase)
      : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    // Clear any previous error and set loading to true
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Basic validation
      if (email.trim().isEmpty || password.trim().isEmpty) {
        throw Exception('Email and password are required');
      }

      // Call the use case
      final user = await signinUsecase.call(email, password);

      if (user == null) {
        throw Exception('Sign in failed. Please try again.');
      }

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

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      if (fullName.trim().isEmpty ||
          email.trim().isEmpty ||
          phoneNumber.trim().isEmpty ||
          password.trim().isEmpty){
            throw Exception("All fields are required");
          } 

            // Email format validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email.trim())) {
        throw Exception('Please enter a valid email address');
      }

      // Password strength validation
      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters long');
      }

      final user = await signupUsecase.call(fullName: fullName, email: email, phoneNumber: phoneNumber, password: password);

      if(user == null){
        throw Exception('Account creation failed. Please try again');
      }

      state = state.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );

      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e)
      );
    }
  }

   Future<void> signInWithGoogle() async {
  state = state.copyWith(isLoading: true, error: null);
  try {
    final user = await googleSignInUsecase.signInwithGoogle(); 

    if (user == null) {
      throw Exception("Google Sign-In failed");
    }

    state = state.copyWith(
      isLoading: false,
      user: user,
      error: null,
    );
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: _getErrorMessage(e),
    );
  }
}

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await FirebaseAuth.instance.signOut();
      
      // Clear the state
      state = state.copyWith(
        isLoading: false,
        user: null,
        error: null,
      );
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
    final errorString = error.toString().toLowerCase();

    // Firebase specific errors
    if (errorString.contains('user-not-found') ||
        errorString.contains('no user found')) {
      return 'No account found with this email address.';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorString.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (errorString.contains('user-disabled')) {
      return 'This account has been disabled.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    }

    // Network and general errors
    if (errorString.contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }

    // Return the original error message if no specific handling
    return error.toString().replaceFirst('Exception: ', '');
  }
}
