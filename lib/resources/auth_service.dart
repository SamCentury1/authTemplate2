import 'package:auth_template/functions/authentication_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // User? get currentUser => _firebaseAuth.currentUser;
  Future<void> createAnonymousUser() async {
    UserCredential cred = await _firebaseAuth.signInAnonymously();
    await _firestore.collection("users").doc(cred.user!.uid).set({
      "uid": cred.user!.uid,
      "username": "",
      "emails": "",
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  Future<void> registerUser(String email, String password) async {
    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    await _firestore.collection("users").doc(cred.user!.uid).set({
      "uid": cred.user!.uid,
      "username": "",
      "email": email,
      "createdAt": DateTime.now().toIso8601String(),
    });      
  }


  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);

    if (cred.additionalUserInfo!.isNewUser) {
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "username": cred.user!.displayName,
        "email": cred.user!.email,
        "createdAt": DateTime.now().toIso8601String(),
      });        
    } 

    return cred;
  }

  // Future<void> signInUser(BuildContext context, String email, String password) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email, 
  //       password: password
  //     );
  //     // Navigator.pop(context);


  //   } on FirebaseAuthException catch (e) {
  //     AuthenticationHelpers().loginFailed(context,e.code);
  //     // Navigator.pop(context);
  //     // if (e.code == 'invalid-credential') {
  //     //   AuthenticationHelpers().loginFailed(context,e.code);
  //     // } else if (e.code == 'invalid-email') {
  //     //   loginFailed(context,e.code);
  //     // } else if (e.code == 'channel-error') {
  //     //   loginFailed(context,e.code);
  //     // }
  //   }  
  // }


  // Future<void> loginUser() async {

  // }


}