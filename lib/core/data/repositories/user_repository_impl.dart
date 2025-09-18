
import 'package:taskly_to_do_app/core/data/datasources/auth_remote_data_source.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';

import 'package:taskly_to_do_app/core/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);
  @override
  Future<AuthUserModel?> loginWithEmailAndPassword(String email, String password) {
   return _authRemoteDataSource.signInWithEmailAndPassword(email, password);
  }
  
  @override
  Future<AuthUserModel?> createUserWithEmailAndPassword({required String fullName, required String email, required String phoneNumber, required String password}) {
    return _authRemoteDataSource.createUserWithEmailAndPassword(fullName: fullName, email: email, phoneNumber: phoneNumber, password: password);
  }
  
  @override
  Future<AuthUserModel> signInWithGoogle() {
    return _authRemoteDataSource.signInwithGoogle();  
  }

}
