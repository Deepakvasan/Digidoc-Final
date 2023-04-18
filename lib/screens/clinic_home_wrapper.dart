import 'package:flutter/material.dart';
import 'package:signup_login/screens/add_doctor.dart';
import 'package:signup_login/screens/clinic_home.dart';
import 'package:signup_login/screens/login_screen.dart';
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

  Future<void> checkInitialised() async {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    isInitialised = await _database.checkIfClinicInitialised(uid!);
    print("Is Initialised value = > ");
    print(isInitialised);
    // print("Initialised" + isInitialised as String);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: checkInitialised(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Book Appointment"),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                actions: [
                  TextButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
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
              body: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            if (isInitialised == 'true') {
              return ClinicHome();
            } else {
              return AddDoctor();
            }
          }
        });
  }
  // checkInitialised();
  //   print(isInitialised.toString());
  //   if (isInitialised != null) {
  //     // return Doc Home Page
  //     if (isInitialised == 'true') {
  //       return Container();
  //     } else {
  //       return AddDoctor();
  //     }
  //   } else {
  //     return const Text("Something Went wrong");
  //   }
  // }

}
