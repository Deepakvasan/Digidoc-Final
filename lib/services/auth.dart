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
  // Future IsFirstTimeLogin()   {

  // }
  Future registerWithEmailAndPassword(String? email, String? password) async {
    try {
      print("password from auth function " + password!);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email as String, password: password as String);
      User user = result.user!;
      print("Successfully logged in");
      print(user);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      print("error");
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

  String? getCurrentUserUid() {
    final User? user = _auth.currentUser;
    if (user != null) {
      // print("Returned user id " + user.uid);
      return user.uid;
    } else {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Password reset email sent
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // User not found
        print("user not found");
      } else {}
    } catch (e) {}
  }
}
