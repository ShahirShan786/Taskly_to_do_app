import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/data/datasources/auth_remote_data_source.dart';

import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/data/repositories/user_repository_impl.dart';
import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';
import 'package:taskly_to_do_app/core/domain/usecases/google_sign_in_usecase.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signin_usecase.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signup_usecase.dart';
import 'package:taskly_to_do_app/core/presentation/notifiers/auth_notifiers.dart';

// Data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// Use case provider
final signinUsecaseProvider = Provider<SigninUsecase>((ref) {
  return SigninUsecase(ref.watch(authRepositoryProvider));
});

final signUpUsecaseProvider = Provider<SignupUsecase>((ref){
return SignupUsecase(ref.watch(authRepositoryProvider));
});

final googleSignInUsecaseProvider = Provider<GoogleSignInUsecase>((ref){
return GoogleSignInUsecase(ref.watch(authRepositoryProvider));
});

// Auth notifier provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifiers, AuthState>((ref) {
  return AuthNotifiers(ref.watch(signinUsecaseProvider), ref.watch(signUpUsecaseProvider), ref.watch(googleSignInUsecaseProvider));
});

// Additional helper providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).user != null;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

final currentUserProvider = Provider<AuthUserModel?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).error;
});

// Optional: Auth state changes stream provider for listening to auth state
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authNotifierProvider.notifier).stream;
});











// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taskly_to_do_app/core/data/models/user_model.dart';
// import 'package:taskly_to_do_app/core/domain/usecases/signin_usecase.dart';
// import 'package:taskly_to_do_app/core/presentation/notifiers/auth_notifiers.dart';

// final signinUsecaseProvider = Provider<SigninUsecase>((ref) {
//  throw UnimplementedError('Implement signinUsecaseProvider with proper repository dependency');
// });

// final authNotifierProvider =
//     StateNotifierProvider<AuthNotifiers, AuthState>((ref) {
//   return AuthNotifiers(ref.watch(signinUsecaseProvider));
// });

// // Additional helper providers
// final isAuthenticatedProvider = Provider<bool>((ref) {
//   return ref.watch(authNotifierProvider).user != null;
// });

// final isLoadingProvider = Provider<bool>((ref) {
//   return ref.watch(authNotifierProvider).isLoading;
// });

// final currentUserProvider = Provider<AuthUserModel?>((ref) {
//   return ref.watch(authNotifierProvider).user;
// });

// final authErrorProvider = Provider<String?>((ref) {
//   return ref.watch(authNotifierProvider).error;
// });