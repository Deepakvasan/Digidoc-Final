import 'package:flutter/material.dart';
import 'package:signup_login/screens/appointments_list.dart';
import 'package:signup_login/screens/clinic_page_test.dart';
import 'package:signup_login/screens/doctor_profile.dart';
import 'package:signup_login/screens/doctor_page.dart';
import 'package:signup_login/screens/faq_page.dart';
import 'package:signup_login/screens/in_appointment_page_home.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/screens/ml_page.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';

class InAppointmentPageChooser extends StatefulWidget {
  AppointmentDetails appointmentDetails;

  InAppointmentPageChooser({
    super.key,
    required this.appointmentDetails,
  });

  @override
  State<InAppointmentPageChooser> createState() =>
      _InAppointmentPageChooserState();
}

class _InAppointmentPageChooserState extends State<InAppointmentPageChooser> {
  final AuthService _auth = AuthService();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      Center(
        child: InAppointmentPageHome(
            appointmentDetails: widget.appointmentDetails),
      ),
      Center(
        child: Text('Reports', style: TextStyle(fontSize: 60)),
      ),
      Center(child: HealthForm()),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(
          "Appointment",
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
              )),
        ],
        leading: null,
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
            icon: Icon(Icons.medical_information_rounded),
            label: 'Diagnose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_sharp),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_unread_chat_alt_outlined),
            label: 'Predict',
          ),
        ],
      ),
    );
  }
}
