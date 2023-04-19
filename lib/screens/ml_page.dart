import 'package:flutter/material.dart';
import 'package:signup_login/services/mlApi.dart';

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

  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Health Form'),
      // ),
      body: Padding(
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
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),
              TextFormField(
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
                onPressed: () {
                  // EmailService email1 = EmailService();
                  dynamic res = MlService().predict();
                  setState(() {
                    result = res;
                  });
                },
              ),
              Text(
                result,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
