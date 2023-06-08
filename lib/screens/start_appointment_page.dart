import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/in_appointment_page_chooser.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class StartAppointmentPage extends StatefulWidget {
  AppointmentDetails appointmentDetails;
  StartAppointmentPage({
    super.key,
    required this.appointmentDetails,
  });

  @override
  State<StartAppointmentPage> createState() => _StartAppointmentPageState();
}

class _StartAppointmentPageState extends State<StartAppointmentPage> {
  String? error = "";
  static GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   error = "";
    // });
    DatabaseService _database = DatabaseService();
    AppointmentDetails appointmentDetails = widget.appointmentDetails;

    TextEditingController _codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Appointment"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Enter 4-digit Code",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: basicFormKey,
                    child: TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: "Get the code from the Patient to enter",
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Cant be empty";
                          }
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(7.73),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                      child: Text("Verify"),
                      padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        print(error);
                        if (basicFormKey.currentState?.validate() ?? false) {
                          if (_codeController.text == appointmentDetails.code) {
                            setState(() {
                              error = "";
                            });
                            //Change status to attended.
                            // await _database.updateAppointmentStatus(
                            //     appointmentDetails.appointmentId, "Ongoing");
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        InAppointmentPageChooser(
                                          appointmentDetails:
                                              appointmentDetails,
                                        )));
                            //Redirect to InAppointmentPage
                          } else {
                            setState(() {
                              error = "Code is Incorrect, Try Again !";
                            });
                          }
                        } else {
                          print("Cant proceed");
                          // setState(() {
                          //   error = "Form not validated" as String;
                          // });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Text(error!, style: TextStyle(color: Colors.red));
                    },
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
