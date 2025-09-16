import 'package:taskly_to_do_app/core/data/models/user_model.dart';

import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';

class SigninUsecase {
final AuthRepository _userRepository;

  SigninUsecase(this._userRepository);

 Future<AuthUserModel?> call (String email , String password){
  return _userRepository.loginWithEmailAndPassword(email, password);
 }
}