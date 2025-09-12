import 'package:taskly_to_do_app/core/data/models/auth_user_model.dart';
import 'package:taskly_to_do_app/core/domain/repositories/user_repository.dart';

class AuthenticationUseCase {
  final UserRepository _userRepository;

  AuthenticationUseCase(this._userRepository);

  Future<AuthUserModel> authenticateUser(String email, String password) async {
    return await _userRepository.authenticateUser(email, password);
  }
}
