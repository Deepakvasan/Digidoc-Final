import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  @override
  final AuthService auth = AuthService();
  final DatabaseService db = DatabaseService();
  Widget build(BuildContext context) {
    final String uid = auth.getCurrentUserUid()!;

    return FutureBuilder(
        future: db.getPatientDetails(uid),
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

            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient Details",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Name : $name",
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Age: $age",
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Phone: $phone",
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Blood Group: $bloodGroup",
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Allergies: $allergies",
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        });
  }
}
