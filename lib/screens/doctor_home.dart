import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/appointmentCard.dart';
import 'package:signup_login/screens/appointmentPage.dart';
import 'package:signup_login/screens/appointmentPageDoctor.dart';
import 'package:signup_login/screens/appointment_card_doctor.dart';
import 'package:signup_login/screens/appointment_page_summary_doctor.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  AuthService _auth = AuthService();
  DatabaseService _database = DatabaseService();

  Widget _getDoctorName(String doctorUid) {
    return FutureBuilder(
        future: _database.getDoctorDetails(doctorUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("${snapshot.error}");
              return Text('Error: ${snapshot.error}');
            }

            var details = snapshot.data;
            // print("OBTAINING FROM Dtabase Service");
            // print(details);
            var name = details![0];
            var category = details![3];
            var phone = details![1];
            var qualification = details![7];
            var clinicName = details![9];
            var clinicAddressLine1 = details![10];
            var clinicAddressLine2 = details![11];

            return Column(children: <Widget>[
              Text(
                "Greetings, Dr. $name",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
            ]);
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final _months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    Future _showAppointments() async {
      var data = _database.getAppointmentList(_auth.getCurrentUserUid()!);
      return data;
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Doctor's Homepage",
            style: TextStyle(fontSize: 21.0),
          ),
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
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _getDoctorName(_auth.getCurrentUserUid()!),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "Your Appointments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('doctorUid', isEqualTo: _auth.getCurrentUserUid())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    var appointments = snapshot.data!.docs
                        .where((doc) => doc['status'] == "Booked")
                        .map((doc) => AppointmentDetails(
                              appointmentId: doc.id,
                              slotBooked: doc['slotChosen'],
                              doctorUid: doc['doctorUid'],
                              sessionTime: doc['sessionTime'],
                              consultationFee: doc['consultationFee'],
                              bookingStatus: doc['status'],
                              timeOfBooking: doc['timeOfBooking'],
                              patientUid: doc['patientUid'],
                              date: doc['date'],
                              code: doc['code'],
                            ))
                        .toList();

                    appointments.sort();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        var appointmentDetails = appointments[index];
                        return InkWell(
                          child: AppointmentCardDoctor(
                            patientName: appointmentDetails.patientUid,
                            slotTime: appointmentDetails.slotBooked,
                            date: appointmentDetails.date,
                            sessionTime: appointmentDetails.sessionTime,
                            consultationFee: appointmentDetails.consultationFee,
                            status: appointmentDetails.bookingStatus,
                          ),
                          onTap: appointmentDetails.bookingStatus == "Booked"
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentPageDoctor(
                                              appointmentDetails:
                                                  appointmentDetails,
                                            )),
                                  );
                                }
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentPageSummaryDoctor(
                                              appointmentDetails:
                                                  appointmentDetails,
                                            )),
                                  );
                                },
                        );
                      },
                    );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Unactive Appointments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('doctorUid', isEqualTo: _auth.getCurrentUserUid())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    var appointments = snapshot.data!.docs
                        .where((doc) => doc['status'] != "Booked")
                        .map((doc) => AppointmentDetails(
                              appointmentId: doc.id,
                              slotBooked: doc['slotChosen'],
                              doctorUid: doc['doctorUid'],
                              sessionTime: doc['sessionTime'],
                              consultationFee: doc['consultationFee'],
                              bookingStatus: doc['status'],
                              timeOfBooking: doc['timeOfBooking'],
                              patientUid: doc['patientUid'],
                              date: doc['date'],
                              code: doc['code'],
                            ))
                        .toList();

                    appointments.sort();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        var appointmentDetails = appointments[index];
                        return InkWell(
                          child: AppointmentCardDoctor(
                            patientName: appointmentDetails.patientUid,
                            slotTime: appointmentDetails.slotBooked,
                            date: appointmentDetails.date,
                            sessionTime: appointmentDetails.sessionTime,
                            consultationFee: appointmentDetails.consultationFee,
                            status: appointmentDetails.bookingStatus,
                          ),
                          onTap: appointmentDetails.bookingStatus == "Booked"
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentPageDoctor(
                                              appointmentDetails:
                                                  appointmentDetails,
                                            )),
                                  );
                                }
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentPageSummaryDoctor(
                                              appointmentDetails:
                                                  appointmentDetails,
                                            )),
                                  );
                                },
                        );
                      },
                    );
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
