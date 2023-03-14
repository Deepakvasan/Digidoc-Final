import 'package:flutter/material.dart';
import 'package:signup_login/screens/add_doctor.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'package:signup_login/screens/choose_login_screen.dart';

class DoctorWrapper extends StatelessWidget {
  DoctorWrapper({super.key});
  final AuthService _auth = AuthService();

  late DatabaseService _database;
  @override
  Widget build(BuildContext context) {
    String uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    dynamic isInitialised = _database.checkIfClinicInitialised(uid);
    print(isInitialised);
    if (isInitialised != null) {
      // return Doc Home Page
      if (isInitialised == 'true') {
        return Container();
      } else {
        return AddDoctor();
      }
    } else {
      return Text("Something Went wrong");
    }
  }
}
