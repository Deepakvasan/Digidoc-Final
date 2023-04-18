import 'package:flutter/material.dart';
import 'package:signup_login/screens/clinic_page.dart';
import 'package:signup_login/screens/doctor_profile.dart';
import 'package:signup_login/screens/doctor_page.dart';
import 'package:signup_login/screens/faq_page.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/screens/reports.dart';
import 'package:signup_login/services/auth.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int currentIndex = 0;
  final screens = [
    Center(
      child: PatientHome(),
    ),
    Center(
      child: DoctorProfile(),
    ),
    Center(child: Reports()),
    Center(child: Text('Profile', style: TextStyle(fontSize: 60))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(
          'Welcome',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryContainer),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return const FaqPage();
                    },
                    isScrollControlled: true,
                  );
                },
                child: Icon(
                  Icons.help,
                  size: 26.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
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
              )),
        ],
      ),
      body: Container(
        child: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => (setState(
          () => currentIndex = index,
        )),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
