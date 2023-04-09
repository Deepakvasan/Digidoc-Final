import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
          backgroundColor: Theme.of(context).primaryColor,
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
          ],
        ),
        body: Center(
          child: Text("Something went wrong"),
        ));
  }
}
