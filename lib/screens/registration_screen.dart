import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:date_field/date_field.dart';
import 'package:signup_login/screens/wrapper.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController bloodController = new TextEditingController();
  final TextEditingController sexController = new TextEditingController();
  final TextEditingController allergyController = new TextEditingController();
  final TextEditingController emergencyController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

  String dateValue = "";
  String _myActivity = "";
  String _myActivityResult = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    dateValue = "";
    _myActivity = "";
    _myActivityResult = "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final AuthService _auth = AuthService();
  // final DatabaseService _database = DatabaseService();

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  int activeIndex = 0;
  int totalIndex = 3;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (activeIndex != 0) {
            activeIndex--;
            setState(() {});
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Signup",
            ),
          ),
          body: bodyBuilder(),
        ));
  }

  Widget bodyBuilder() {
    switch (activeIndex) {
      case 0:
        return firstRegPage();
      case 1:
        return secondRegPage();
      case 2:
        return thirdRegPage();
      default:
        return firstRegPage();
    }
  }

  Widget firstRegPage() {
    final textField = Flexible(
      child: Container(
        child: Text(
          "Hi there, we just need a few details from you, to set things up ",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );

    final minitextfield = Flexible(
      child: Container(
        width: double.infinity,
        child: Text(
          "Personal Details",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    final nameField = TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: "Name",
      ),
      validator: RequiredValidator(
        errorText: "Required *",
      ),
    );

    final dobField = DateTimeFormField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.redAccent),
        suffixIcon: Icon(Icons.event_note),
        hintText: "Date Of Birth",
      ),
      mode: DateTimeFieldPickerMode.date,
      autovalidateMode: AutovalidateMode.always,
      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      onDateSelected: (DateTime value) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(value);
        print(formattedDate);
        setState(() {
          dateValue = formattedDate;
        });
      },
    );

    final emailField = TextFormField(
      controller: emailController,
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

    final phoneField = TextFormField(
      controller: phoneController,
      decoration: const InputDecoration(
        labelText: "Phone",
      ),
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

    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (basicFormKey.currentState?.validate() ?? false) {
            // next
            setState(() {
              activeIndex++;
            });
          }
        },
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
    );

    return Container(
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
            textField,
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(12),
                width: 368,
                lineHeight: 5.0,
                percent: ((activeIndex + 1) / totalIndex),
                progressColor: Theme.of(context).primaryColorDark,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            minitextfield,
            SizedBox(
              height: 25,
            ),
            nameField,
            SizedBox(
              height: 25,
            ),
            dobField,
            SizedBox(
              height: 25,
            ),
            emailField,
            SizedBox(
              height: 25,
            ),
            phoneField,
            SizedBox(
              height: 30,
            ),
            nextButton,
          ],
        ),
      ),
    );
  }

  Widget secondRegPage() {
    final textField = Flexible(
      child: Container(
        child: Text(
          "Just a few more steps and we can get you started",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );

    final minitextfield = Flexible(
      child: Container(
        width: double.infinity,
        child: Text(
          "Medical Details",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    final bloodField = TextFormField(
      controller: bloodController,
      decoration: const InputDecoration(
        labelText: "Blood Group",
      ),
      validator: ((value) {
        if (value == "A+" ||
            value == "A-" ||
            value == "B+" ||
            value == "B-" ||
            value == "O+" ||
            value == "O-" ||
            value == "AB+" ||
            value == "AB-") {
          return null;
        } else {
          return 'Possible Blood Types [A+, A-, B+, B-, O+, O-, AB+, AB-]';
        }
      }),
    );
    final sexField = TextFormField(
      controller: sexController,
      decoration: const InputDecoration(
        labelText: "Sex",
      ),
      validator: RequiredValidator(
        errorText: "Required *",
      ),
    );
    final allergiesField = TextFormField(
      controller: allergyController,
      decoration: const InputDecoration(
        labelText: "Allergies (If Any)",
      ),
      validator: RequiredValidator(
        errorText: "Required *",
      ),
    );

    final emergencyField = TextFormField(
      controller: emergencyController,
      decoration: const InputDecoration(
        labelText: "Emergency Contacts",
      ),
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

    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (basicFormKey.currentState?.validate() ?? false) {
            // next
            setState(() {
              activeIndex++;
            });
          }
        },
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
    );

    return Container(
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
            textField,
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(12),
                width: 368,
                lineHeight: 5.0,
                percent: ((activeIndex + 1) / totalIndex),
                progressColor: Theme.of(context).primaryColorDark,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            minitextfield,
            SizedBox(
              height: 20,
            ),
            bloodField,
            SizedBox(
              height: 25,
            ),
            sexField,
            SizedBox(
              height: 25,
            ),
            allergiesField,
            SizedBox(
              height: 25,
            ),
            emergencyField,
            SizedBox(
              height: 30,
            ),
            nextButton,
          ],
        ),
      ),
    );
  }

  Widget thirdRegPage() {
    final textField = Flexible(
      child: Container(
        width: double.infinity,
        child: Text(
          "Almost there, final steps",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    final minitextfield = Flexible(
      child: Container(
        width: double.infinity,
        child: Text(
          "Confirmation",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      validator: RequiredValidator(
        errorText: "Required *",
      ),
    );

    final confirmPasswordField = TextFormField(
      controller: confirmPasswordController,
      decoration: const InputDecoration(
        labelText: "Confirm Password",
      ),
      validator: (val) {
        if (!val!.isEmpty && val == passwordController.text) {
          return null;
        } else {
          return 'Not Matching with password';
        }
      },
    );

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (basicFormKey.currentState?.validate() ?? false) {
            // next

            print(nameController.text +
                " " +
                phoneController.text +
                " " +
                dateValue +
                " " +
                emailController.text +
                " " +
                bloodController.text +
                " " +
                allergyController.text +
                " " +
                sexController.text +
                " " +
                emergencyController.text +
                " " +
                passwordController.text +
                " " +
                confirmPasswordController.text);
            setState(() {
              if (activeIndex == totalIndex) {
                print("Successfully Signed up!");
              }
            });
            dynamic result = await _auth.registerWithEmailAndPassword(
                emailController.text, confirmPasswordController.text);
            //if null -> couldnt login / signin.
            if (result == null) {
              print("Error signining in!");
              const snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              print('Signed in using email and password');
              //Adding user record to users collection as that of UID.
              print("UID = " + result.uid);
              // final DatabaseService _database =
              await DatabaseService(uid: result.uid).updatePatientUserData(
                nameController.text,
                phoneController.text,
                dateValue,
                bloodController.text,
                allergyController.text,
                sexController.text,
                emergencyController.text,
              );

              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => Wrapper()));
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => Wrapper()));
              print(result.uid);
            }
          }
        },
        child: Text(
          "Sign Up",
        ),
      ),
    );

    return Container(
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
            textField,
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(12),
                width: 368,
                lineHeight: 5.0,
                percent: ((activeIndex + 1) / totalIndex),
                progressColor: Theme.of(context).primaryColorDark,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            minitextfield,
            SizedBox(
              height: 20,
            ),
            passwordField,
            SizedBox(
              height: 25,
            ),
            confirmPasswordField,
            SizedBox(
              height: 25,
            ),
            registerButton,
          ],
        ),
      ),
    );
  }
}
