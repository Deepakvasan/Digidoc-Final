import 'package:flutter/material.dart';
import 'package:signup_login/screens/clinic_home_wrapper.dart';
import 'package:signup_login/screens/doctor_home_wrapper.dart';
import 'package:signup_login/screens/error_page.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  AuthService _auth = AuthService();

  String? uid = '';

  String userType = '';
  void fetchUserType() async {
    try {
      uid = _auth.getCurrentUserUid();
      print(uid);
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          userType = userDoc['userType'];
        });
      }
      // print("The user is of type : " + userType);

    } catch (e) {
      try {
        var clinicsCollection = FirebaseFirestore.instance
            .collection("users")
            .where("userType", isEqualTo: "clinic");
        var clinicsQuerySnapshot = await clinicsCollection.get();
        for (final clinic in clinicsQuerySnapshot.docs) {
          final doctorsCollection = clinic.reference.collection("doctors");
          final documentRef = doctorsCollection.doc(uid);
          DocumentSnapshot<Map<String, dynamic>> docSnapshot =
              await documentRef.get();
          if (docSnapshot.exists) {
            print("doctor");
            userType = 'doctor';
            break;
          }
        }
      } catch (e) {
        print('Error fetching user type name: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel?>(context);
    //return either home or authenticate widget based on auth status
    fetchUserType();
    print("userType =" + userType);

    if (userType == 'patient') {
      return Home();
    } else if (userType == 'clinic') {
      return const ClinicHomeWrapper();
    } else {
      return const DoctorHomeWrapper();
    }
  }
}
