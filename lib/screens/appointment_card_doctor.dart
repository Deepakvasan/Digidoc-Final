import 'package:flutter/material.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class AppointmentCardDoctor extends StatelessWidget {
  final String patientName;
  final dynamic slotTime;
  final String sessionTime;
  final String consultationFee;
  final String date;
  final String status;

  AppointmentCardDoctor(
      {required this.patientName,
      required this.slotTime,
      required this.date,
      required this.sessionTime,
      required this.consultationFee,
      required this.status});

  Widget _getPatientDetails(String patientUid) {
    //Change this to Patient Name
    DatabaseService _database = DatabaseService();
    AuthService _auth = AuthService();
    return FutureBuilder(
        future: _database.getPatientDetails(patientUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("${snapshot.error}");
              return Text('Error: ${snapshot.error}');
            }

            var details = snapshot.data;
            // print("OBTAINING FROM Dtabase Service");
            // print(details);
            //[name, phone, sex, bloodGroup, allergies,age]
            var name = details![0];
            var phone = details![1];
            var sex = details![2];
            var bloodGroup = details![3];
            var allergies = details![4];
            var age = details![5];

            return Text("$name");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _getDoctorName(String doctorUid) {
    DatabaseService _database = DatabaseService();
    AuthService _auth = AuthService();
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
            return Text("$name");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color(0xff5fc8c8),
                Color(0xff6ff0f2),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getPatientDetails(patientName),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8.0),
                    Text(
                        "$date [ ${slotTime['hour']} : ${slotTime['minute']} ]"),
                    // Text(" -> ${status}",
                    // style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 8.0),
                    Text(sessionTime),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.currency_rupee),
                    const SizedBox(width: 8.0),
                    Text('\$$consultationFee'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
