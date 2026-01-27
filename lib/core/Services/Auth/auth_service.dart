import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/Models/App User/app_user.model.dart';
import '../../../Data/Repositories/user.repo.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpWithEmailAndPassword({
    required AppUser appUser,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: appUser.email,
        password: password,
      );
      appUser.id = userCredential.user!.uid;
      await AppUserRepo().createSingle(
        appUser,
        itemId: appUser.id,
      );

      return true;
    } catch (e) {
      // SnackbarHelper.showTemplated(context,
      //     content: Text('Error: ${e.toString()}'), title: 'Signup Error');
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   SnackbarHelper.showTemplated(context,
      //       content: const Text('No user found for that email.'),
      //       title: "Invalid User");
      // } else if (e.code == 'wrong-password') {
      //   SnackbarHelper.showTemplated(context,
      //       title: 'Wrong password.',
      //       content: const Text("Wrong password provided for that user."));
      // }
      return null;
    } catch (e) {
      debugPrint('Sign in failed: $e');
      return null;
    }
  }

  Stream<User?> isUserLoggedIn() {
    return _auth.authStateChanges();
  }

  String getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }
}
