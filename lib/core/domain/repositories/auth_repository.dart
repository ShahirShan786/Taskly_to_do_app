

import 'package:taskly_to_do_app/core/data/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthUserModel?>  loginWithEmailAndPassword(String email, String password);
}
