import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/doctor_profile_complete.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/screens/reset_page.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class DoctorAccountWrapper extends StatefulWidget {
  const DoctorAccountWrapper({super.key});

  @override
  State<DoctorAccountWrapper> createState() => _DoctorAccountWrapperState();
}

// Here it has to check whether profile is complete / password resetted.
class _DoctorAccountWrapperState extends State<DoctorAccountWrapper> {
  // late Future<String?> checkInitial;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late DatabaseService _database;
  final AuthService _auth = AuthService();
  String? uid;
  dynamic isComplete;
  Future<dynamic> checkComplete() async {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    setState(() {
      isComplete = _database.checkIfDoctorComplete(uid!);
    });
    print("Is Complete value = > ");
    // print(isInitialised.toString());
    return isComplete;
    // print("Initialised" + isInitialised as String);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: checkComplete(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool complete = snapshot.data!;
            if (complete == true) {
              //check further if account complete and then account verified
              return PatientHome();
            } else {
              return DoctorProfileComplete();
            }
          } else if (snapshot.hasError) {
            //should create a error page with string pssed as constructor
            print("${snapshot.error!}");
            return Text("${snapshot.error!}");
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
