import 'package:signup_login/screens/home_screen.dart';

import 'reports.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../services/storage_service.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  @override
  // Service classes

  Storage storage = Storage();

  // State variables

  String filename = "";
  String _name = "", _path = "";
  List<String> typeOfReports = [
    "Electrocardiogram (ECG)",
    "Blood Test",
    "CT scan",
    "MRI scan",
    "X-ray",
    "Ultrasound",
    "General Report",
  ];
  String reportType = "General Report";

  // Text controller

  TextEditingController nameController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload your report",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Container(
          height: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),

              // Name input of report

              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter name for the report",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),

              // Report Type

              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: DropdownButton<String>(
                  value: reportType,
                  onChanged: (newValue) {
                    setState(() {
                      reportType = newValue!;
                      print("Report type changed $reportType");
                    });
                  },
                  items: typeOfReports.map<DropdownMenuItem<String>>(
                    (type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          "$type",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  hint: Text("Select report type"),
                  isExpanded: true,
                  underline: const SizedBox(),
                ),
              ),

              // Subtitle for file picker

              Container(
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select the file :",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),

              // File picker

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ["png", "jpg", "heic", "pdf"],
                            type: FileType.custom,
                          );

                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No files selected !!!"),
                              ),
                            );

                            return null;
                          }
                          final tpath = result.files.single.path;
                          final tname = result.files.single.name;
                          setState(() {
                            filename = tname;
                            this._name = tname;
                            this._path = tpath!;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(80, 80),
                            shape: CircleBorder(),
                            backgroundColor: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.file_open,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("File Browser")
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          PickedFile? pickedFile = await ImagePicker().getImage(
                            source: ImageSource.camera,
                            maxHeight: 2400,
                            maxWidth: 2400,
                          );
                          if (pickedFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Photo not taken !!!"),
                              ),
                            );
                            setState(() {
                              filename = "";
                            });
                            return null;
                          }
                          print("Image taken successfully !!");
                          File imageFile = File(pickedFile.path);
                          setState(() {
                            filename = "Photo from camera";
                            _name = basename(imageFile.path);
                            _path = imageFile.path;
                          });
                        },
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 30.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(80, 80),
                          shape: CircleBorder(),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Camera"),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              // Filename display

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      filename == "" ? "No Document selected" : filename,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          filename = "";
                          _name = "";
                          _path = "";
                        });
                      },
                      child: Icon(Icons.delete),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              // Upload Button

              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_path == "" || _name == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a file !"),
                        ),
                      );
                      return null;
                    }
                    if (nameController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter a name for the file !"),
                        ),
                      );
                      return null;
                    }
                    storage
                        .uploadFile(
                      _path,
                      nameController.text,
                      reportType,
                      context,
                    )
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    });
                  },
                  icon: Icon(
                    Icons.upload,
                    size: 28.0,
                  ),
                  label: Text("UPLOAD FILE"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(20.0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
