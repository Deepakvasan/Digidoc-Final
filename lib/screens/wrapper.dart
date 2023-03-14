import 'package:flutter/material.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/screens/user_type_wrapper.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'authenticate/authenticate.dart';
import 'package:signup_login/screens/choose_login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    print("Stream Status : ");
    print(user);
    //return either home or authenticate widget based on auth status
    if (user == null) {
      return const LoginScreen();
    } else {
      return UserTypeWrapper();
    }
  }
}
