import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracking_app/models/authclass.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class AuthService {
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInwithGoogle() async {
    try {
      final googlesignin = GoogleSignIn.instance;
      googlesignin.initialize(
        clientId: dotenv.env['GOOGLE_CLIENT_ID'],
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID']
      );
      final GoogleSignInAccount googleUser =
          await googlesignin.authenticate();

      final GoogleSignInAuthentication googleauth = googleUser.authentication;
      
      final credential =
          GoogleAuthProvider.credential(idToken: googleauth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      // return FirebaseAuth.instance.currentUser;
      // return AuthResult(user: FirebaseAuth.instance.currentUser);
      // return AuthResult(success: true);
      return Success();
    } on FirebaseAuthException catch(e){
        if(e.code == 'network-request-failed'){
          return Failure(errorMessage: "No internet connection. Try again.");
        }else {
          return Failure(errorMessage: "Unable to sign in (code: ${e.code}). Please try again.");
        }
    } on PlatformException catch(e){
      if (e.code == 'sign_in_canceled') {
        return Failure(errorMessage: "Sign-in canceled");
      } else {
        return Failure(errorMessage: "Unable to sign in (code: ${e.code}). Please try again.");
      }
    }
    catch (e) {
      // if (e.)
      // return AuthResult(success:false,errorMessage:'Unable to Login :$e');
      return Failure(errorMessage: "Something went wrong . Please try again. $e");
    }
    // final GoogleSignInAccount? googleUser =
    //     await GoogleSignIn.instance.authenticate();
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignInAccount? googleSignInAccount =
    //     await googleSignIn.signIn();
    // if (googleSignInAccount != null) {
    //   final GoogleSignInAuthentication googleSignInAuthentication =
    //       await googleSignInAccount.authentication;
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleSignInAuthentication.accessToken,
    //     idToken: googleSignInAuthentication.idToken,
    //   );

    //   try {
    //     final UserCredential userCredential =
    //         await _auth.signInWithCredential(credential);

    //     return userCredential.user;
    //   } on FirebaseAuthException catch (e) {
    //     if (context.mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text("An error occurred. Please try again.${e.code}"),
    //           behavior: SnackBarBehavior.floating,
    //         ),
    //       );
    //     }
    //     return null;
    //   }
    // } else {
    //   return null;
    // }
  }

  Future<AuthResult> signOut() async {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // throw Exception("forced exception");
      // await _auth.signOut();
      // await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      // return AuthResult(user: )
      // return AuthResult(success: true);
      return Success();
    } catch (e) {

      // return AuthResult(success: false, errorMessage: 'An error occured $e');
      return Failure(errorMessage: 'An error occured $e');
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("An error occurred. Please try again"),
      //       behavior: SnackBarBehavior.floating,
      //     ),
      //   );
      // }
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

// Future<void> hellowWorld() async {
//   try {
//       final result = await FirebaseFunctions.instanceFor(region: 'asia-south1').httpsCallable('helloWorld').call();
      // print("-------------------------------------$result");
      
//   }catch(e){
//     print('error ------------------------ $e');
//   }
// }

Future<AuthResult> deleteUserData() async {
  try {
       await FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('deleteUserAndData')
          .call();
      return Success(); 
    } catch (e) {
      return Failure(errorMessage: 'error deleting $e');
    }
}
  // Future<void> deleteUserData() async {
  //   try {
  //     final result = await FirebaseFunctions.instance.httpsCallable('hellowWorld').call();
  // }catch(e){

  // }
  // Future deleteAccount() async {
  //   try {
  //     if (_auth.currentUser == null) return;
  //     final userDoc = FirebaseFirestore.instance.doc(_auth.currentUser!.uid);
  //     // await deleteUserData(userDoc);
 
  //   } catch (e) {
  //     print("Error");
  //   }
  // }


  // Future deleteUserData(DocumentReference userDoc) async {
  //   final collections = await userDoc.firestore.collection(collectionPath)
  // }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
