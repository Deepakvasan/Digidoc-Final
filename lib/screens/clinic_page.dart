import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/docCard.dart';
import 'package:signup_login/screens/doctor_page.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class ClinicPage extends StatefulWidget {
  ClinicDetails clinicDetails;
  ClinicPage({
    super.key,
    required this.clinicDetails,
  });

  @override
  State<ClinicPage> createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  DatabaseService _database = DatabaseService();
  var doctorDetailsList = [];
  Future<void> _getDoctorList(String id) async {
    doctorDetailsList = [];
    var doctorsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("doctors");
    var doctorsList = await _database.getListOfDoctors(id);
    print(doctorsList.length);
    for (int i = 0; i < doctorsList.length; i++) {
      var doctor = doctorsList[i];
      var snapshot = await doctorsCollection.doc(doctor).get();
      var data = snapshot.data();
      if (data != null) {
        var doctorDetails = DoctorDetails(
            documentId: doctor,
            designation: data["category"],
            name: data["name"],
            qualification: data["qualification"]);
        if (!doctorDetailsList.contains(doctorDetails)) {
          doctorDetailsList.add(doctorDetails);
        }
      }
      print(doctorDetailsList);
    }
  }

  // Widget _getDoctorName(String doctorUid) {
  //   DatabaseService _database = DatabaseService();
  //   AuthService _auth = AuthService();
  //   return FutureBuilder(
  //       future: _database.getDoctorDetails(doctorUid),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasError) {
  //             print("${snapshot.error}");
  //             return Text('Error: ${snapshot.error}');
  //           }

  //           var details = snapshot.data;
  //           // print("OBTAINING FROM Dtabase Service");
  //           // print(details);
  //           var name = details![0];
  //           var category = details![3];
  //           var phone = details![1];
  //           var qualification = details![7];
  //           var clinicName = details![9];
  //           var clinicAddressLine1 = details![10];
  //           var clinicAddressLine2 = details![11];

  //           return Column(children: [
  //             Text("You'r Appointment in $clinicName"),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text("Doctor: $name"),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text("$qualification"),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text("$category"),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Text("Address to Clinic"),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Text("$clinicAddressLine1, $clinicAddressLine2"),
  //           ]);
  //         } else {
  //           return const CircularProgressIndicator();
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    var id = widget.clinicDetails.clinicId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clinic Overview"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  "List of Doctors",
                  style: TextStyle(fontSize: 20),
                ),
                FutureBuilder<void>(
                    future: _getDoctorList(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        print("APPOINTMENT");
                        print(doctorDetailsList.length);
                        print(doctorDetailsList);
                        return Container(
                          height: 600.0,
                          child: Expanded(
                            child: doctorDetailsList.length > 0
                                ? ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    itemCount: doctorDetailsList.length,
                                    itemBuilder: (context, index) {
                                      print(doctorDetailsList.length);
                                      print("INDEX");
                                      print(index);
                                      final doctorDetails =
                                          doctorDetailsList[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: DocCard(
                                            designation:
                                                doctorDetails.designation,
                                            name: doctorDetails.name,
                                            qualification:
                                                doctorDetails.qualification,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorPage(
                                                        DoctorUid: doctorDetails
                                                            .documentId,
                                                      )),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("No Doctors"),
                                    ),
                                  ),
                          ),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
