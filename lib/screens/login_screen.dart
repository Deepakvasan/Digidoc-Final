import 'package:flutter/material.dart';
import 'package:signup_login/screens/registration_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/screens/wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final passState = true;
  String error = '';
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      validator: (val) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val as String)) {
          return null;
        } else {
          return 'Invalid Email Id';
        }
      },
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) {
        emailController.text = newValue!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        hintText: "E-mail",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
    final passwordField = TextFormField(
      validator: (val) => val!.isEmpty ? 'Enter a password' : null,
      autofocus: false,
      controller: passwordController,
      obscureText: passState,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (newValue) {
        passwordController.text = newValue!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_rounded),
        hintText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
        suffixIcon: Icon(Icons.password),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(7.73),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            print("Form Validated");
            dynamic result = await _auth.signInWithEmailAndPassword(
                emailController.text, passwordController.text);
            if (result == null) {
              setState(() {
                error = 'Couldnt Sign In with these credentials';
              });
            } else {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => Wrapper()));
            }
          }
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    emailField,
                    SizedBox(
                      height: 15,
                    ),
                    passwordField,
                    SizedBox(
                      height: 35,
                    ),
                    loginButton,
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Don't have an account ?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.purple[700],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(error),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
