import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/screens/start_appointment_page.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class InAppointmentPageHome extends StatefulWidget {
  AppointmentDetails appointmentDetails;
  InAppointmentPageHome({
    super.key,
    required this.appointmentDetails,
  });

  @override
  State<InAppointmentPageHome> createState() => _InAppointmentPageHomeState();
}

class _InAppointmentPageHomeState extends State<InAppointmentPageHome> {
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

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Name : $name"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Age: $age"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Phone: $phone"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Blood Group: $bloodGroup"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Allergies: $allergies"),
                  SizedBox(
                    height: 10,
                  ),
                ]);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService _database = DatabaseService();
    AppointmentDetails appointmentDetails = widget.appointmentDetails;
    final TextEditingController _diagnosisController = TextEditingController();
    GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
    print("Patient uid");
    print(widget.appointmentDetails.patientUid);

    Widget submitDiagnosisButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to end the appointment'),
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
                        if (basicFormKey.currentState?.validate() ?? false) {
                          //Change status to attended.
                        }
                        //Redirect to InAppointmentPage

                        await _database.updateDiagnosis(
                            appointmentDetails.appointmentId,
                            _diagnosisController.text);
                        // await _database.cancelAppointment(
                        //     widget.appointmentDetails.appointmentId);
                        //[TODO] CAN POSSIBLY ADD A EMAIL SEND TO THESE EMAILS IDS INFORMING

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
                ],
              );
            },
          );
        },
        child: Text("End Appointment"),
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Appointment Details"),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getPatientDetails(appointmentDetails.patientUid),
                  SizedBox(height: 20),
                  Text(
                    "Appointment Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Enter Your Diagnosis"),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: basicFormKey,
                    child: TextFormField(
                      controller: _diagnosisController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter your diagnosis here',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your diagnosis';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  submitDiagnosisButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
