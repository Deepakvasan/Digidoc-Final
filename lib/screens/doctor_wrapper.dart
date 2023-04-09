import 'package:flutter/material.dart';
import 'package:signup_login/screens/add_doctor.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class DoctorWrapper extends StatelessWidget {
  DoctorWrapper({super.key});
  final AuthService _auth = AuthService();
  String? uid;
  dynamic isInitialised;
  late DatabaseService _database;
  void checkInitialised() {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    isInitialised = _database.checkIfClinicInitialised(uid!);
    print("Initialised" + isInitialised);
  }

  @override
  Widget build(BuildContext context) {
    checkInitialised();
    if (isInitialised != null) {
      // return Doc Home Page
      if (isInitialised == 'true') {
        return Container();
      } else {
        return AddDoctor();
      }
    } else {
      return const Text("Something Went wrong");
    }
  }
}
