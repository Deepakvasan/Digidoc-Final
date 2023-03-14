import 'package:flutter/material.dart';
import 'package:signup_login/screens/clinic_home.dart';
import 'package:signup_login/screens/doctor_home.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'home_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTypeWrapper extends StatefulWidget {
  const UserTypeWrapper({super.key});

  @override
  State<UserTypeWrapper> createState() => _UserTypeWrapperState();
}

class _UserTypeWrapperState extends State<UserTypeWrapper> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  AuthService _auth = AuthService();

  String uid = '';

  String userType = '';

  void fetchUserType() async {
    try {
      uid = _auth.getCurrentUserUid();
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userType = userDoc['userType'];
        print("The user is of type : " + userType);
      });
    } catch (e) {
      print('Error fetching clinic name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel?>(context);
    fetchUserType();
    //return either home or authenticate widget based on auth status
    if (userType == 'patient') {
      return Home();
    } else if (userType == 'clinic') {
      return ClinicHome();
    } else {
      return DoctorHome();
    }
  }
}
