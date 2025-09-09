import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracking_app/main.dart';

class AuthService {
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInwithGoogle({required BuildContext context}) async {
    if (isIntegrationTest) {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: 'test@gmail.com', password: '123456');
      return userCredential.user;
    }

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("An error occurred. Please try again.${e.code}"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return null;
      }
    } else {
      return null;
    }
  }

  Future signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // throw Exception("forced exception");
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred. Please try again"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  bool needesReauthentication() {
    try {
      if (_auth.currentUser == null) {
        return true;
      }
      final lastSigninTime = _auth.currentUser!.metadata.lastSignInTime;
      if (lastSigninTime == null) {
        return true;
      }
      final now = DateTime.now();
      final diffrence = now.difference(lastSigninTime);
      if (diffrence.inMinutes < 5) {
        return false;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Future deleteAccount() async {
    try {
      if (_auth.currentUser == null) return;
      final userDoc = FirebaseFirestore.instance.doc(_auth.currentUser!.uid);
      // await deleteUserData(userDoc);
      //TODO 
    } catch (e) {
      print("Error");
    }
  }

  //TODO
  // Future deleteUserData(DocumentReference userDoc) async {
  //   final collections = await userDoc.firestore.collection(collectionPath)
  // }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
