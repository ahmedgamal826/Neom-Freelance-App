import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    String email,
    String password, [
    BuildContext? context,
  ]) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
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

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final UserCredential webCredential =
            await _auth.signInWithPopup(googleProvider);
        return webCredential.user;
      }

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the Google picker.
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return null;
      }

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final List<String> nameParts = (firebaseUser.displayName ?? '')
            .trim()
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .toList();

        final String firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
        final String secondName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Google';

        final AppUser appUser = AppUser(
          id: firebaseUser.uid,
          firstName: firstName,
          secondName: secondName,
          email: firebaseUser.email ?? googleUser.email,
        );

        await AppUserRepo().createSingle(
          appUser,
          itemId: appUser.id,
        );
      }

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('Google sign in failed: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Google sign in failed: $e');
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

  Future<void> signOut([BuildContext? context]) async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }
}
