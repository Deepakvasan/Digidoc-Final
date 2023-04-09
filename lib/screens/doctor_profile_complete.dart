import 'package:flutter/material.dart';
import 'package:signup_login/screens/fix_timings_of_doctor.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:signup_login/services/database.dart';
import 'package:signup_login/services/formLists.dart';

class DoctorProfileComplete extends StatefulWidget {
  const DoctorProfileComplete({super.key});

  @override
  State<DoctorProfileComplete> createState() => _DoctorProfileCompleteState();
}

class _DoctorProfileCompleteState extends State<DoctorProfileComplete> {
  TextEditingController consultationFeeController = TextEditingController();
  TextEditingController aimController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  String? stateMedicalCouncil = stateMedicalCouncilLists[1];
  String? category = categoryLists[1];

  String? name = "";
  String? phone = "";
  String? categoryString = "";
  String? email = "";
  String? initialised = "";

  late DatabaseService _database;
  final AuthService _auth = AuthService();
  String? uid;
  late List<dynamic> docDetails;
  Future<List<dynamic>> getDocDetails() async {
    uid = _auth.getCurrentUserUid();
    _database = DatabaseService(uid: uid);
    var isInitialised = await _database.getDoctorDetails(uid!);
    print(isInitialised);
    // docDetails = await isInitialised;
    return isInitialised;
  }

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getDocDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            docDetails = snapshot.data!;
            name = docDetails[0];
            phone = docDetails[1];
            email = docDetails[2];
            categoryString = docDetails[3];
            initialised = docDetails[4];
            final nameField = TextFormField(
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              initialValue: name!,
              enabled: false,
              validator: RequiredValidator(
                errorText: "Required *",
              ),
            );

            final phoneField = TextFormField(
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
              initialValue: phone!,
              enabled: false,
              validator: MultiValidator(
                [
                  RequiredValidator(
                    errorText: "Required *",
                  ),
                  MinLengthValidator(
                    10,
                    errorText: "Invalid Phone Number",
                  ),
                ],
              ),
            );
            final consultationFeeField = TextFormField(
              controller: consultationFeeController,
              decoration: const InputDecoration(
                labelText: "Consultation Fee",
              ),
              validator: RequiredValidator(
                errorText: "Required *",
              ),
            );
            final aimField = TextFormField(
              controller: aimController,
              decoration: const InputDecoration(
                labelText: "NMC Registration Number",
              ),
              validator: (value) {
                if (value!.length < 2) {
                  return "Should be more than 2 digits";
                } else {
                  return null;
                }
              },
            );
            final stateMedicalCouncilField = DropdownButtonFormField(
              hint: Text("State Medical Field"),
              value: stateMedicalCouncil!,
              onChanged: (value) {
                setState(() {
                  stateMedicalCouncil = value as String;
                });
              },
              items: stateMedicalCouncilLists
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
            );
            final categoryField = DropdownButtonFormField(
              value: category!,
              items: categoryLists
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
            );
            final qualificationField = TextFormField(
              controller: qualificationController,
              decoration: const InputDecoration(
                labelText: "Enter Your Qualifications",
              ),
              validator: (value) {
                if (value!.length < 3) {
                  return "Should be longer";
                } else {
                  return null;
                }
              },
            );
            final proceedButton = Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(7.73),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async {
                  if (basicFormKey.currentState?.validate() ?? false) {
                    // next
                    uid = _auth.getCurrentUserUid();
                    _database = DatabaseService(uid: uid);
                    try {
                      await _database.updateDoctorProfile(
                        name: name!,
                        phone: phone!,
                        email: email!,
                        qualification: qualificationController.text,
                        category: category,
                        consultationFee: consultationFeeController.text,
                        aimNumber: aimController.text,
                      );

                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FixTimingsOfDoctor()));
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: Text("Proceed"),
              ),
            );
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Profile Completion"),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  actions: [
                    TextButton.icon(
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Fill in the below details to set up your profile",
                          style: TextStyle(
                            fontSize: 34,
                          ),
                        ),
                        Form(
                          key: basicFormKey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              nameField,
                              SizedBox(
                                height: 25,
                              ),
                              phoneField,
                              SizedBox(
                                height: 25,
                              ),
                              aimField,
                              SizedBox(
                                height: 25,
                              ),
                              stateMedicalCouncilField,
                              SizedBox(
                                height: 25,
                              ),
                              qualificationField,
                              SizedBox(
                                height: 25,
                              ),
                              consultationFeeField,
                              SizedBox(
                                height: 25,
                              ),
                              proceedButton,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
