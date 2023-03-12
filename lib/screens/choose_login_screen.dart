import 'package:flutter/material.dart';
import 'package:signup_login/screens/login_screen.dart';

class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose your login',
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: InkWell(
                            onTap: () {
                              // Link to login page
                            },
                            child: Image.asset(
                              "assets/clinicphoto.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text("Clinics")
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 16),
              Flexible(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Image.asset(
                              "assets/patientphoto.jpeg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Patients",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
