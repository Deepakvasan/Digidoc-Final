import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/doctor_account_wrapper.dart';
import 'package:signup_login/screens/reset_page.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class DoctorHomeWrapper extends StatefulWidget {
  const DoctorHomeWrapper({super.key});

  @override
  State<DoctorHomeWrapper> createState() => _DoctorHomeWrapperState();
}

// Here it has to check whether profile is complete / password resetted.
class _DoctorHomeWrapperState extends State<DoctorHomeWrapper> {
  // late Future<String?> checkInitial;

  void initState() {
    super.initState();
    // checkInitial = checkInitialised();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late DatabaseService _database;
  final AuthService _auth = AuthService();
  String? uid;
  dynamic isInitialised;
  Future<dynamic> checkInitialised() async {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    setState(() {
      isInitialised = _database.checkIfDoctorInitialised(uid!);
    });
    print("Is Initialised value = > ");
    // print(isInitialised.toString());
    return isInitialised;
    // print("Initialised" + isInitialised as String);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: checkInitialised(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String initialised = snapshot.data!;
            if (initialised == 'true') {
              //check further if account complete and then account verified
              return const DoctorAccountWrapper();
            } else {
              String? email = FirebaseAuth.instance.currentUser!.email;
              return ResetPassword(email: email);
            }
          } else if (snapshot.hasError) {
            //should create a error page with string pssed as constructor
            return Text("${snapshot.error!}");
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
