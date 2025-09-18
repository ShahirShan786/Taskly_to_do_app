import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly_to_do_app/core/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';
abstract class AuthRemoteDataSource {
  Future<AuthUserModel?> signInWithEmailAndPassword(String email, String password);
  Future<AuthUserModel?> createUserWithEmailAndPassword({required String fullName , required String email , required String phoneNumber ,required String password});
  Future<AuthUserModel> signInwithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthUserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if (credential.user != null) {
        return AuthUserModel.fromFirebaseUser(credential.user!);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }
      
      log("Firebase Auth Error: ${e.code} - ${e.message}");
      throw Exception(errorMessage);
    } catch (e) {
      log("Unexpected error: $e");
      throw Exception('An unexpected error occurred during sign in');
    }
  }
  
  @override
  Future<AuthUserModel?> createUserWithEmailAndPassword({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user != null) {
        // Store additional details in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return AuthUserModel(
          uid: user.uid,
          email: user.email ?? '',
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak. Please choose a stronger password.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled. Please contact support.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection and try again.';
          break;
        default:
          errorMessage = 'Account creation failed: ${e.message ?? 'Unknown error'}';
      }
      
      log("Firebase Auth Error during signup: ${e.code} - ${e.message}");
      throw Exception(errorMessage);
    } on FirebaseException catch (e) {
      // Handle Firestore errors separately
      log("Firestore Error: ${e.code} - ${e.message}");
      throw Exception('Failed to save user data. Please try again.');
    } catch (e) {
      log("Unexpected error during signup: $e");
      throw Exception('An unexpected error occurred during account creation. Please try again.');
    }
  }
  
  @override
  Future<AuthUserModel> signInwithGoogle() async{
       final FirebaseAuth auth = FirebaseAuth.instance;
     final FirebaseFirestore firestore = FirebaseFirestore.instance;
     final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // Trigger the Google Sign-In flow
      final googleUser = await googleSignIn.signIn();
      // Handle the case where the user cancels the sign-in flow
      if (googleUser == null) {
        throw Exception("Google Sign-In aborted by user");
      }

      // Obtain auth details
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Save to Firestore if new user
      final userDoc = firestore.collection("Users").doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          "fullName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoURL,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return AuthUserModel.fromFirebaseUser(user);
    } catch (e) {
      // Re-throw with a more specific error message for easier debugging
    log("$e");
      throw Exception("Google Sign-In failed: $e");
    }
  }
}