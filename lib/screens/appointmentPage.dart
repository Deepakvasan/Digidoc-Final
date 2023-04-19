import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentDetails appointmentDetails;
  AppointmentPage({
    super.key,
    required this.appointmentDetails,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
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
            var category = details![3];
            var phone = details![1];
            var qualification = details![7];
            var clinicName = details![9];
            var clinicAddressLine1 = details![10];
            var clinicAddressLine2 = details![11];

            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Appointment in $clinicName",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Doctor: $name"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("$qualification"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("$category"),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Address to Clinic",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("$clinicAddressLine1, $clinicAddressLine2"),
                  ]),
            );
          } else {
            return Row(
              children: [
                Text(
                  "Getting Clinic details",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15.0,
                ),
                CircularProgressIndicator(),
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService _database = DatabaseService();
    AppointmentDetails appointmentDetails = widget.appointmentDetails;
    Widget cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to cancel the appointment?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      await _database.cancelAppointment(
                          widget.appointmentDetails.appointmentId);

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Text("Cancel Appointment"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getDoctorName(appointmentDetails.doctorUid),
                  SizedBox(height: 20),
                  Text(
                    "Appointment Details: ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Appointment On ${appointmentDetails.date}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Time: ${appointmentDetails.slotBooked['hour']}:${appointmentDetails.slotBooked['minute']}",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Appointment duration: ${appointmentDetails.sessionTime}"),
                  SizedBox(height: 20),
                  Text("Status: ${appointmentDetails.bookingStatus}"),
                  SizedBox(height: 20),
                  appointmentDetails.bookingStatus == "Booked"
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Share this code on visiting the doctor",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "${appointmentDetails.code}",
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            cancelButton,
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
