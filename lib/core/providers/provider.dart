import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/domain/usecases/signin_usecase.dart';
import 'package:taskly_to_do_app/core/presentation/notifiers/auth_notifiers.dart';

final signinUsecaseProvider = Provider<SigninUsecase>((ref) {
 throw UnimplementedError('Implement signinUsecaseProvider with proper repository dependency');
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifiers, AuthState>((ref) {
  return AuthNotifiers(ref.watch(signinUsecaseProvider));
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