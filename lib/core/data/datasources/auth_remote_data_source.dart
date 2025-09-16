import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';

abstract class AuthRemoteDataSource{
  Future<AuthUserModel?>singInWithEmailAndPassword(String email , String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  @override
  Future<AuthUserModel?> singInWithEmailAndPassword(String email , String password) async{
   try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password
  );
  if(credential.user != null){
    return AuthUserModel.fromFirebaseUser(credential.user!);
  }
  return null;
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
  return null;
}catch(e){
 log("Unexpected error: $e");
 return null;
}
  }

}