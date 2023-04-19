import 'package:flutter/material.dart';
import 'package:signup_login/screens/clinic_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:signup_login/services/database.dart';
import 'package:signup_login/services/email.dart';
import 'dart:math';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  DatabaseService _database = DatabaseService();
  Widget statusIcon() {
    //Here it checks if email is sent to the doctor and if he created his account by logining in once.
    bool loginStatus = false;
    if (loginStatus) {
      return Text("Account Initialised",
          style: TextStyle(color: Colors.lightGreenAccent[700]));
    } else {
      return Text(
        "Mail Sent",
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      );
    }
  }

  AuthService _auth = AuthService();
  String clinicName = '';
  String uid = '';
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? uid = _auth.getCurrentUserUid();
    CollectionReference clinicRef =
        FirebaseFirestore.instance.collection('users');
    DocumentReference clinicDocRef = clinicRef.doc(uid);
    CollectionReference doctorsRef = clinicDocRef.collection('doctors');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text("Add Doctors"),
        actions: [
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
              ))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: doctorsRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Text('Welcome, ${clinicName}. \nPlease Add your doctors'),
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((doc) => ListTile(
                                title: Text(doc['name']),
                                subtitle: Text(
                                    doc['email'] + "  (" + doc['phone'] + ")"),
                                trailing: statusIcon(),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(7.73),
                      color: Theme.of(context).primaryColor,
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
                        minWidth: MediaQuery.of(context).size.width - 300,
                        onPressed: () {
                          if (snapshot.data!.docs.length > 0) {
                            String? uid = _auth.getCurrentUserUid();
                            _database.makeInitialisedTrue(uid);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ClinicHome()));
                          } else {
                            print("Please add doctors");
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("No Doctors Added"),
                                content: const Text(
                                    "You have to add atleast one doctor."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Theme.of(context).primaryColor,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text(
                                        "okay",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Done"),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Doctor'),
                  content: Form(
                    key: basicFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Name cant be empty" : null),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(
                                errorText: "Required *",
                              ),
                              EmailValidator(
                                errorText: "Not Valid Email",
                              )
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                          ),
                          validator: (value) => value!.length == 10
                              ? null
                              : "Enter a valid phone number",
                        ),
                        TextFormField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            labelText: 'Category',
                          ),
                          validator: (value) => value!.length > 1
                              ? null
                              : "Enter a valid category",
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Save'),
                      onPressed: () async {
                        if (basicFormKey.currentState?.validate() ?? false) {
                          //[TODO] if(same doctor not there with same phone number or email)
                          dynamic data = await clinicDocRef.get();
                          const _chars =
                              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                          Random _rnd = Random.secure();

                          String getRandomString(int length) =>
                              String.fromCharCodes(Iterable.generate(
                                  length,
                                  (_) => _chars.codeUnitAt(
                                      _rnd.nextInt(_chars.length))));
                          String password = getRandomString(10);
                          print(password);
                          // dynamic result = null;
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  _emailController.text, password);

                          print("Clinic name" + data['name']);
                          print(result.uid);
                          if (result != null) {
                            EmailService _email = EmailService();
                            dynamic res = _email.sendEmail(
                                name: _nameController.text,
                                email: _emailController.text,
                                clinicName: data['name'],
                                password: password);

                            await DatabaseService(uid: uid).addDoctorCollection(
                              result.uid,
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _categoryController.text,
                            );
                            // await doctorsRef.doc(result.uid).set({
                            //   'name': _nameController.text,
                            //   'email': _emailController.text,
                            //   'phone': _phoneController.text,
                            // });

                            _nameController.clear();
                            _emailController.clear();
                            _phoneController.clear();
                            _categoryController.clear();

                            Navigator.of(context).pop();
                          } else {
                            print("Error creating account");
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          label: const Text('Add Doctors'),
          icon: const Icon(Icons.add)),
    );
  }
}
