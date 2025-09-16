import 'package:taskly_to_do_app/core/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({required super.uid, required super.email});

  factory AuthUserModel.fromFirebaseUser(user) {
    return AuthUserModel(uid: user.uid, email: user.email ?? "");
  }
}
