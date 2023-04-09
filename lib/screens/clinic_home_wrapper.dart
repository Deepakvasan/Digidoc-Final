import 'package:flutter/material.dart';
import 'package:signup_login/screens/add_doctor.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class ClinicHomeWrapper extends StatefulWidget {
  const ClinicHomeWrapper({super.key});

  @override
  State<ClinicHomeWrapper> createState() => _ClinicHomeWrapperState();
}

class _ClinicHomeWrapperState extends State<ClinicHomeWrapper> {
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
  dynamic isInitialised;

  void checkInitialised() {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    setState(() {
      isInitialised = _database.checkIfClinicInitialised(uid!);
    });
    print("Is Initialised value = > ");
    print(isInitialised);
    // print("Initialised" + isInitialised as String);
  }

  @override
  Widget build(BuildContext context) {
    checkInitialised();
    print(isInitialised.toString());
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
