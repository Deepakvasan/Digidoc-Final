import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final AuthService auth = AuthService();
  String? uid = "";
  String? doctoruid = "";
  CollectionReference? reports;
  Storage(this.uid) {
    reports = FirebaseFirestore.instance.collection("reports");
    // uid = auth.getCurrentUserUid();
    doctoruid = auth.getCurrentUserUid();
    print("Patient uid in storage class ${uid}");
  }

  Future<void> uploadReportData(
    String filename,
    String reportType,
  ) {
    return reports!.add({
      'filename': filename,
      'reportType': reportType,
      'uploadedBy': doctoruid,
      'uploadedAt': DateTime.now().toString(),
    }).then((value) {
      print("Report Data added");
    }).catchError((e) {
      print("Failed to add record $e");
    });
  }

  Future<void> uploadFile(
    String filepath,
    String filename,
    String reportType,
    BuildContext context,
  ) async {
    File file = File(filepath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Upload started"),
      ),
    );
    try {
      print("Upload process started");
      print("Uploading to ${uid}");
      await storage.ref('users/$uid/$reportType/$filename/').putFile(file).then(
        (p0) {
          uploadReportData(filename, reportType).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Document Uploaded successfully!!"),
              ),
            );
          }).catchError((e) {
            print("Failed to upload $e");
          });
        },
      ).catchError((e) {
        print("Failed to upload $e");
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload Failed !!"),
        ),
      );
    }
  }

  Future<firebase_storage.ListResult> listFiles(String type) async {
    firebase_storage.ListResult results =
        await storage.ref('users/$uid/$type').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print("Found file: $ref");
    });
    return results;
  }

  Future<void> downloadFile(
    String type,
    String name,
    BuildContext context,
  ) async {
    String url = await storage.ref('users/$uid/$type/$name').getDownloadURL();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Download Started !!"),
      ),
    );
    FileDownloader.downloadFile(
      url: url,
      onDownloadCompleted: (String path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File downloaded to $path")),
        );
      },
    );
  }

  Future<void> delete(String type, String name) async {
    await storage.ref('users/$uid/$type/$name').delete().then(
          (value) => print("File Deleted successfully.."),
        );
  }
}
