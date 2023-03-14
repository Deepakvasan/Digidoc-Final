import 'package:flutter/material.dart';
import 'package:signup_login/services/auth.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
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
      body: Text('doctor Home Page'),
    );
  }
}
