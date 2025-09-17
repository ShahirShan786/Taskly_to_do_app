import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository _authRepository;

  SignupUsecase(this._authRepository);

  Future<AuthUserModel?> call({required String fullName, required String email, required String phoneNumber, required String password}){
    return _authRepository.createUserWithEmailAndPassword(fullName: fullName, email: email, phoneNumber: phoneNumber, password: password);
  }
}