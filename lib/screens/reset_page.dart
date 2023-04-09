import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:signup_login/screens/doctor_home_wrapper.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPassword extends StatefulWidget {
  String? email;
  ResetPassword({Key? key, this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void makeInitialisedTrue() async {
    AuthService _auth = AuthService();
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(_auth.getCurrentUserUid());
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        break;
      }
    }
    await documentRef
        .update({"initialised": "true"})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    // _auth.resetPassword(widget.email!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text("Reset Password"),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
              },
              icon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColorDark,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _auth.resetPassword(widget.email!);
            makeInitialisedTrue();
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => DoctorHomeWrapper()));
          },
          child: Text('Reset Password'),
        ),
      ),
    );
  }
}
