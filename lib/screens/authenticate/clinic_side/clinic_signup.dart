import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:signup_login/screens/clinic_home_wrapper.dart';
import 'package:signup_login/screens/doctor_wrapper.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class ClinicSignUp extends StatefulWidget {
  const ClinicSignUp({super.key});

  @override
  State<ClinicSignUp> createState() => _ClinicSignUpState();
}

class _ClinicSignUpState extends State<ClinicSignUp> {
  late AnimationController _controller;

  final TextEditingController clinicNameController =
      new TextEditingController();
  final TextEditingController clinicEmailController =
      new TextEditingController();
  final TextEditingController clinicAddressLine1Controller =
      new TextEditingController();
  final TextEditingController clinicAddressLine2Controller =
      new TextEditingController();
  final TextEditingController clinicPasswordController =
      new TextEditingController();
  final TextEditingController clinicConfirmPasswordController =
      new TextEditingController();

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final clinicNameField = TextFormField(
      controller: clinicNameController,
      decoration: const InputDecoration(
        labelText: "Clinic's Name",
      ),
      validator: ((value) => value!.isEmpty ? 'Name cant be empty' : null),
    );
    final clinicEmailField = TextFormField(
      controller: clinicEmailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      validator: MultiValidator(
        [
          RequiredValidator(
            errorText: "Required *",
          ),
          EmailValidator(
            errorText: "Not Valid Email",
          ),
        ],
      ),
    );

    final clinicAddressLine1 = TextFormField(
      controller: clinicAddressLine1Controller,
      decoration: const InputDecoration(
        labelText: "House Number, Street",
      ),
      validator: ((value) => value!.isEmpty ? 'Name cant be empty' : null),
    );
    final clinicAddressLine2 = TextFormField(
      controller: clinicAddressLine2Controller,
      decoration: const InputDecoration(
        labelText: "Area",
      ),
      validator: ((value) => value!.isEmpty ? 'Name cant be empty' : null),
    );
    // final clinicAddressCity  =
    final clinicPasswordField = TextFormField(
      controller: clinicPasswordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      validator: RequiredValidator(
        errorText: "Required *",
      ),
    );

    final clinicConfirmPasswordField = TextFormField(
      controller: clinicConfirmPasswordController,
      decoration: const InputDecoration(
        labelText: "Confirm Password",
      ),
      validator: (val) {
        if (!val!.isEmpty && val == clinicPasswordController.text) {
          return null;
        } else {
          return 'Not Matching with password';
        }
      },
    );
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      textStyle:
          TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (basicFormKey.currentState?.validate() ?? false) {
            dynamic result = await _auth.registerWithEmailAndPassword(
                clinicEmailController.text, clinicPasswordController.text);
            //   //if null -> couldnt login / signin.
            if (result == null) {
              print("Error signining in!");
              var snackBar = SnackBar(
                content: Text('Error Signin In !'),
                action: SnackBarAction(
                  label: 'close',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              print('Signed in using email and password');
              //     //Adding user record to users collection as that of UID.
              print("UID = " + result.uid);
              // final DatabaseService _database = DatabaseService(uid: uid);
              await DatabaseService(uid: result.uid).updateClinicUserData(
                  clinicNameController.text,
                  clinicEmailController.text,
                  clinicAddressLine1Controller.text,
                  clinicAddressLine2Controller.text);

              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => Wrapper()));

              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => ClinicHomeWrapper()));
              print(result.uid);
            }
          }
        },
        child: Text(
          "Sign Up",
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(
          'Sign up your clinic',
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: basicFormKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              clinicNameField,
              SizedBox(
                height: 15,
              ),
              clinicEmailField,
              SizedBox(
                height: 15,
              ),
              clinicAddressLine1,
              SizedBox(
                height: 15,
              ),
              clinicAddressLine2,
              SizedBox(
                height: 15,
              ),
              clinicPasswordField,
              SizedBox(
                height: 15,
              ),
              clinicConfirmPasswordField,
              SizedBox(
                height: 25,
              ),
              signupButton,
            ],
          ),
        ),
      ),
    );
  }
}
