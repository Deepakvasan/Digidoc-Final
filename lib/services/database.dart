import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final String? uid;
  DatabaseService({this.uid});

  Future updateUserData(
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
    });
  }
}
