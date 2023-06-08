import 'package:flutter/material.dart';
import 'package:signup_login/services/mlApi.dart';
import 'dart:convert';

class HealthForm extends StatefulWidget {
  @override
  _HealthFormState createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {
  final _formKey = GlobalKey<FormState>();
  String? age;
  String? sex;
  String? bp;
  String? cholesterol;
  String? wbcc;
  String? rbcc;
  String? glucose;
  String? insulin;
  String? bmi;
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController cholestrolController = TextEditingController();
  TextEditingController wbccController = TextEditingController();
  TextEditingController rbccController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController insulinController = TextEditingController();
  TextEditingController bmiController = TextEditingController();

  var result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Health Form'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Enter Values to Predict",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                  ),
                  controller: ageController,
                  onChanged: (value) {
                    setState(() {
                      age = value;
                    });
                  },
                ),
                TextFormField(
                  controller: sexController,
                  decoration: InputDecoration(
                    labelText: 'Sex',
                  ),
                  onChanged: (value) {
                    setState(() {
                      sex = value;
                    });
                  },
                ),
                TextFormField(
                  controller: bpController,
                  decoration: InputDecoration(
                    labelText: 'Blood Pressure',
                  ),
                  onChanged: (value) {
                    setState(() {
                      bp = value;
                    });
                  },
                ),
                TextFormField(
                  controller: cholestrolController,
                  decoration: InputDecoration(
                    labelText: 'Cholesterol',
                  ),
                  onChanged: (value) {
                    setState(() {
                      cholesterol = value;
                    });
                  },
                ),
                TextFormField(
                  controller: wbccController,
                  decoration: InputDecoration(
                    labelText: 'White Blood Cell Count',
                  ),
                  onChanged: (value) {
                    setState(() {
                      wbcc = value;
                    });
                  },
                ),
                TextFormField(
                  controller: rbccController,
                  decoration: InputDecoration(
                    labelText: 'Red Blood Cell Count',
                  ),
                  onChanged: (value) {
                    setState(() {
                      rbcc = value;
                    });
                  },
                ),
                TextFormField(
                  controller: glucoseController,
                  decoration: InputDecoration(
                    labelText: 'Glucose',
                  ),
                  onChanged: (value) {
                    setState(() {
                      glucose = value;
                    });
                  },
                ),
                TextFormField(
                  controller: insulinController,
                  decoration: InputDecoration(
                    labelText: 'Insulin',
                  ),
                  onChanged: (value) {
                    setState(() {
                      insulin = value;
                    });
                  },
                ),
                TextFormField(
                  controller: bmiController,
                  decoration: InputDecoration(
                    labelText: 'BMI',
                  ),
                  onChanged: (value) {
                    setState(() {
                      bmi = value;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    // EmailService email1 = EmailService();
                    setState(() {
                      result = MlService().predict(
                          ageController.text,
                          sexController.text,
                          bpController.text,
                          cholestrolController.text,
                          wbccController.text,
                          rbccController.text,
                          glucoseController.text,
                          insulinController.text,
                          bmiController.text);
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Text("${result[0]}"),
                // Text("${result[1]}"),
                // Text("${result[2]}"),
                FutureBuilder(
                  future: MlService().predict(
                      ageController.text,
                      sexController.text,
                      bpController.text,
                      cholestrolController.text,
                      wbccController.text,
                      rbccController.text,
                      glucoseController.text,
                      insulinController.text,
                      bmiController.text),
                  builder: (context, snapshot) {
                    if (ageController.text.isNotEmpty &&
                        sexController.text.isNotEmpty &&
                        bpController.text.isNotEmpty &&
                        cholestrolController.text.isNotEmpty &&
                        wbccController.text.isNotEmpty &&
                        rbccController.text.isNotEmpty &&
                        glucoseController.text.isNotEmpty &&
                        insulinController.text.isNotEmpty &&
                        bmiController.text.isNotEmpty) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LinearProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        print("MAP");
                        String hd = snapshot.data["HeartDisease"] == "True"
                            ? "High"
                            : "Low";
                        String kd = snapshot.data["KidneyDisease"] == "True"
                            ? "High"
                            : "Low";
                        String db = snapshot.data["diabetes"] == "True"
                            ? "High"
                            : "Low";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Risk for Common Diseases"),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Heart Diseases: $hd'),
                            Text('Kidney Diseases: $kd'),
                            Text('Diabetes: $db'),
                          ],
                        );
                      }
                    } else {
                      return LinearProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
