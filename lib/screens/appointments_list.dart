import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:signup_login/screens/appointmentCard.dart';
import 'package:signup_login/screens/appointmentPage.dart';
import 'package:signup_login/screens/appointment_page_summary_patient.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({super.key});

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  late DatabaseService _database;
  AuthService _auth = AuthService();
  var appointmentBookedDetailsList = [];
  var appointmentOtherDetailsList = [];
  String? uid;
  Future<void> _retrieveAppointmentDetails() async {
    _database = DatabaseService();
    uid = _auth.getCurrentUserUid();
    var listOfAppointments = await _database.getAllPatientAppointments(uid);
    var appointmentsCollection =
        FirebaseFirestore.instance.collection("appointments");
    print(listOfAppointments);
    var appointmentDetails;
    appointmentBookedDetailsList = [];
    if (listOfAppointments != null) {
      print("LIST OF APPOINTMENTS");
      print(listOfAppointments);
      print(listOfAppointments.length);
      for (int i = 0; i < listOfAppointments.length; i++) {
        var appointments = listOfAppointments[i];
        var docRef = appointmentsCollection.doc(appointments);
        var data = await docRef.get();
        if (data.exists) {
          var appointmentData = data.data()!;
          var appointmentDetails = AppointmentDetails(
            appointmentId: appointments,
            slotBooked: appointmentData['slotChosen'],
            consultationFee: appointmentData['consultationFee'],
            sessionTime: appointmentData['sessionTime'],
            bookingStatus: appointmentData['status'],
            timeOfBooking: appointmentData['timeOfBooking'],
            doctorUid: appointmentData['doctorUid'],
            patientUid: appointmentData['patientUid'],
            date: appointmentData['date'],
            code: appointmentData['code'],
          );
          // appointmentDetails.printer();
          // print("RESUTL");
          // print(appointmentDetailsList.contains(appointmentDetails));
          // if (!appointmentDetailsList.contains(appointmentDetails)) {
          //   appointmentDetailsList.add(appointmentDetails);
          // }
          print(appointmentDetails.bookingStatus);
          if (appointmentDetails.bookingStatus == "Booked") {
            appointmentBookedDetailsList.add(appointmentDetails);
          }

          print(appointmentBookedDetailsList);
          appointmentBookedDetailsList.sort();
          // Do something with the appointmentDetails object, such as adding it to a list
        } else {
          print('No documents found in the appointments collection.');
        }
      }
    }
    // do like get todays day and show his timings and only list if available in this time, if not available dont add in the list.
  }

  Future<void> _retrieveOtherAppointmentDetails() async {
    _database = DatabaseService();
    uid = _auth.getCurrentUserUid();
    var listOfAppointments = await _database.getAllPatientAppointments(uid);
    var appointmentsCollection =
        FirebaseFirestore.instance.collection("appointments");
    print(listOfAppointments);
    var appointmentDetails;
    appointmentOtherDetailsList = [];
    if (listOfAppointments != null) {
      print("LIST OF APPOINTMENTS");
      print(listOfAppointments);
      print(listOfAppointments.length);
      for (int i = 0; i < listOfAppointments.length; i++) {
        var appointments = listOfAppointments[i];
        var docRef = appointmentsCollection.doc(appointments);
        var data = await docRef.get();
        if (data.exists) {
          var appointmentData = data.data()!;
          var appointmentDetails = AppointmentDetails(
            appointmentId: appointments,
            slotBooked: appointmentData['slotChosen'],
            consultationFee: appointmentData['consultationFee'],
            sessionTime: appointmentData['sessionTime'],
            bookingStatus: appointmentData['status'],
            timeOfBooking: appointmentData['timeOfBooking'],
            doctorUid: appointmentData['doctorUid'],
            patientUid: appointmentData['patientUid'],
            date: appointmentData['date'],
            code: appointmentData['code'],
          );
          // appointmentDetails.printer();
          // print("RESUTL");
          // print(appointmentDetailsList.contains(appointmentDetails));
          // if (!appointmentDetailsList.contains(appointmentDetails)) {
          //   appointmentDetailsList.add(appointmentDetails);
          // }
          print(appointmentDetails.bookingStatus);
          if (appointmentDetails.bookingStatus != "Booked") {
            appointmentOtherDetailsList.add(appointmentDetails);
          }

          print(appointmentOtherDetailsList);
          appointmentOtherDetailsList.sort();
          // Do something with the appointmentDetails object, such as adding it to a list
        } else {
          print('No documents found in the appointments collection.');
        }
      }
    }
    // do like get todays day and show his timings and only list if available in this time, if not available dont add in the list.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(
                "Active Appointments",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.all(12.0),
            ),
            FutureBuilder<void>(
              future: _retrieveAppointmentDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  print("APPOINTMENT");
                  print(appointmentBookedDetailsList.length);
                  print(appointmentBookedDetailsList);
                  return Container(
                    height: 600.0,
                    child: Expanded(
                      child: appointmentBookedDetailsList.length > 0
                          ? ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: appointmentBookedDetailsList.length,
                              itemBuilder: (context, index) {
                                print(appointmentBookedDetailsList.length);
                                print("INDEX");
                                print(index);
                                final appointmentDetails =
                                    appointmentBookedDetailsList[index];
                                return InkWell(
                                  child: AppointmentCard(
                                    doctorName: appointmentDetails.doctorUid,
                                    slotTime: appointmentDetails.slotBooked,
                                    sessionTime: appointmentDetails.sessionTime,
                                    consultationFee:
                                        appointmentDetails.consultationFee,
                                    date: appointmentDetails.date,
                                    status: appointmentDetails.bookingStatus,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppointmentPage(
                                          appointmentDetails:
                                              appointmentDetails,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No Active Appointments"),
                              ),
                            ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                "Other Appointments",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.all(12.0),
            ),
            FutureBuilder<void>(
              future: _retrieveOtherAppointmentDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  print("APPOINTMENT");
                  print(appointmentOtherDetailsList.length);
                  print(appointmentOtherDetailsList);
                  return Container(
                    height: 600.0,
                    child: Expanded(
                      child: appointmentOtherDetailsList.length > 0
                          ? ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: appointmentOtherDetailsList.length,
                              itemBuilder: (context, index) {
                                print(appointmentOtherDetailsList.length);
                                print("INDEX");
                                print(index);
                                final appointmentDetails =
                                    appointmentOtherDetailsList[index];
                                return InkWell(
                                  child: AppointmentCard(
                                    doctorName: appointmentDetails.doctorUid,
                                    slotTime: appointmentDetails.slotBooked,
                                    sessionTime: appointmentDetails.sessionTime,
                                    consultationFee:
                                        appointmentDetails.consultationFee,
                                    date: appointmentDetails.date,
                                    status: appointmentDetails.bookingStatus,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentPageSummaryPatient(
                                                appointmentDetails:
                                                    appointmentDetails,
                                              )),
                                    );
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No Appointments"),
                              ),
                            ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
