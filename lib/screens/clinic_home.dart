import 'package:flutter/material.dart';
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
    );
  }
}
