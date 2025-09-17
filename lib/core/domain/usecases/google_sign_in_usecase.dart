import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';

class GoogleSignInUsecase {
  final AuthRepository _authRepository;

  GoogleSignInUsecase(this._authRepository);

  Future<AuthUserModel> signInwithGoogle(){
    return _authRepository.signInWithGoogle();
  }
}