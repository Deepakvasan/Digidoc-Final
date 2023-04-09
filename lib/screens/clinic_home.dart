import 'package:flutter/material.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';

class ClinicHome extends StatefulWidget {
  const ClinicHome({super.key});

  @override
  State<ClinicHome> createState() => _ClinicHomeState();
}

class _ClinicHomeState extends State<ClinicHome> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
          ]),
      body: Text('Clinic Home Page'),
      // Should Add Base clinic dashboard, Options to add doctors in some profile tab or something., This clinic should be in the app only after it has one verified doctor. (Unverified doctors will be removed from the list and be never shown until they provide necessary documents ? ? How to do that I dont know.)
    );
  }
}
