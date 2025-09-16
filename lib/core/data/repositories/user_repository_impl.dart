
import 'package:taskly_to_do_app/core/data/datasources/auth_remote_data_source.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';

import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);
  @override
  Future<AuthUserModel?> loginWithEmailAndPassword(String email, String password) {
   return _authRemoteDataSource.singInWithEmailAndPassword(email, password);
  }

}
