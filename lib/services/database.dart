import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final String? uid;
  DatabaseService({this.uid});

  Future updateClinicUserData(
    String clinicName,
    String clinicEmail,
    String clinicAddressLine1,
    String clinicAddressLine2,
  ) async {
    return await userCollection.doc(uid).set({
      'name': clinicName,
      'email': clinicEmail,
      'addressLine1': clinicAddressLine1,
      'addressLine2': clinicAddressLine2,
      'initialised': 'false',
      'userType': 'clinic'
    });
  }

  Future addDoctorCollection(String docName, String docEmail, String docPhone,
      String docQualification, String docCategory) async {
    return await userCollection.doc(uid).collection('doctors').add({
      'name': docName,
      'email': docEmail,
      'phone': docPhone,
      'qualification': null,
      'category': null,
      'consulationFee': null,
      'timings': null,
      'aimNumber': null,
      'verified': false,
      'complete': false,
      'userType': 'doctor'
    });
  }

  Future checkIfClinicInitialised(String uid) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      dynamic initialised = data['initialised'];
      print("initialised" + initialised);
      return initialised;
    } else {
      print('Document does not exist!');
      return null;
    }
  }

  Future updatePatientUserData(
      String name,
      String phone,
      String dob,
      String bloodGroup,
      String Allergies,
      String sex,
      String emergencyContact) async {
    print("UID is $uid");
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'sex': sex,
      'Allergies': Allergies,
      'emergencyContact': emergencyContact,
      'userType': 'patient',
    });
  }
}
