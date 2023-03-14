import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //creating custom user model.
  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null as UserModel;
  }

  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      print(user);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email password
  Future signInWithEmailAndPassword(String? email, String? password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email as String, password: password as String);
      User user = result.user!;
      print(user);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String? email, String? password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email as String, password: password as String);
      User user = result.user!;
      print(user);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getCurrentUserUid() {
    final User? user = _auth.currentUser;
    if (user != null) {
      // print("Returned user id " + user.uid);
      return user.uid;
    } else {
      return null;
    }
  }
}
