import 'package:signup_login/services/auth.dart';

import 'reportView.dart';
import 'upload_document.dart';
import 'package:flutter/material.dart';

const List<String> typeOfReports = [
  "Electrocardiogram (ECG)",
  "Blood Test",
  "CT scan",
  "MRI scan",
  "X-ray",
  "Ultrasound",
  "General Report",
];

class ReportsPatient extends StatefulWidget {
  const ReportsPatient({super.key});
  @override
  State<ReportsPatient> createState() => _ReportsPatientState();
}

class _ReportsPatientState extends State<ReportsPatient> {
  @override
  AuthService auth = AuthService();
  Widget build(BuildContext context) {
    String uid = auth.getCurrentUserUid()!;
    print("Patient uid in reports of patient ${uid}");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadDocument(patientUid: uid),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Your uploaded reports by categories : ",
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ReportListItem(
                    parentContext: context,
                    name: typeOfReports[index],
                    patientUid: uid,
                  );
                },
                itemCount: typeOfReports.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportListItem extends StatelessWidget {
  final BuildContext parentContext;
  final String name;
  final String patientUid;

  ReportListItem(
      {required this.parentContext,
      required this.name,
      required this.patientUid});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          parentContext,
          MaterialPageRoute(
            builder: (context) =>
                ReportView(reportType: name, patientUid: patientUid),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Theme.of(parentContext).primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(parentContext).primaryColor.withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade800,
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 4.0)
            ]),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              child: Icon(
                Icons.file_copy_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "$name",
              style: TextStyle(
                fontSize: 17.0,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
