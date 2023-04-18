import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/services/auth.dart';
import 'dart:math';

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

  AuthService _auth = AuthService();
  Future getPatientName(String? uid) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      dynamic name = data['name'];
      // print("initialised" + initialised);r
      return name;
    } else {
      print('Document does not exist!');
      return null;
    }
  }

  Future addDoctorCollection(
      String DocUid, String docName, String docEmail, String docPhone) async {
    return await userCollection.doc(uid).collection('doctors').doc(DocUid).set({
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
      'initialised': 'false',
      'userType': 'doctor'
    });
  }

  Future checkIfDoctorInitialised(String uid) async {
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    dynamic initialised = "";
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        initialised = data['initialised'];
        break;
      }
    }

    print("initialised" + initialised);
    return initialised;
  }

  Future checkIfClinicInitialised(String uid) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      dynamic initialised = data['initialised'];
      // print("initialised" + initialised);r
      return initialised;
    } else {
      print('Document does not exist!');
      return null;
    }
  }

  Future checkIfDoctorComplete(String uid) async {
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    dynamic complete = false;
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        complete = data['complete'];
        break;
      }
    }

    print("Complete ");
    print(complete);
    return complete;
  }

  Future getListOfDoctors(String id) async {
    List<String> docIds = [];
    var doctorsSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("doctors")
        .get();

    doctorsSnapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });

    print(docIds);
    return docIds;
  }

  Future updatePatientUserData(
      String name,
      String phone,
      String dob,
      String bloodGroup,
      String allergies,
      String sex,
      String emergencyContact) async {
    print("UID is $uid");

    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'sex': sex,
      'Allergies': allergies,
      'emergencyContact': emergencyContact,
      'userType': 'patient',
    });
  }

  Future<List<dynamic>> getDoctorDetails(String uid) async {
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    var clinicData;
    dynamic name = "";
    dynamic phone = "";
    dynamic category = "";
    dynamic initialised = "";
    dynamic email = "";
    dynamic consultationFee = "";
    dynamic timings = {};
    dynamic qualification = "";
    dynamic consultationTime = "";
    dynamic clinicName = "";
    dynamic clinicAddressLine1 = "";
    dynamic clinicAddressLine2 = "";
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      clinicData = clinic.data();
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        name = data['name'];
        phone = data['phone'];
        email = data['email'];
        initialised = data['initialised'];
        consultationTime = data['consultationTime'];
        consultationFee = data['consulationFee'];
        category = data['category'];
        timings = data['timings'];
        qualification = data['qualification'];
        clinicName = clinicData['name'];
        clinicAddressLine1 = clinicData['addressLine1'];
        clinicAddressLine2 = clinicData['addressLine2'];
        break;
      }
    }
    List<dynamic> details = [
      name,
      phone,
      email,
      category,
      initialised,
      consultationFee,
      timings,
      qualification,
      consultationTime,
      clinicName,
      clinicAddressLine1,
      clinicAddressLine2
    ];
    // print("DETAILS ");
    // print(details);
    return details;
  }

  Future getAllPatientAppointments(String? uid) async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
    var data = await docRef.get();
    print("data");

    if (data.exists && data.data()!.containsKey("appointmentId")) {
      var listOfAppointments = data.data()!["appointmentId"];
      return listOfAppointments;
    } else {
      return null;
    }
  }

  Future isPatientFree(var slotchosed, var date, var sessionTime) async {
    String? uid = _auth.getCurrentUserUid();
    final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
    var data = await docRef.get();
    print("data");
    bool result = true;

    if (data.exists && data.data()!.containsKey("appointmentId")) {
      var listOfAppointments = data.data()!["appointmentId"];
      for (var appointmentId in listOfAppointments) {
        print(appointmentId);
        final appointmentsRef = FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointmentId);

        var data = await appointmentsRef.get();
        var slot = data.data()!["slotChosen"];
        print(slot.runtimeType);
        print(slot['hour']);
        print(slot['hour'].runtimeType);

        var dates = data.data()!["date"];
        var session = data.data()!["sessionTime"];
        print(slotchosed['hour'].runtimeType);
        int maxChosedTimeHour = slotchosed['hour'];
        int maxChosedTimeMinutes =
            slotchosed['minute'] + int.parse(sessionTime);
        if (maxChosedTimeMinutes > 60) {
          maxChosedTimeHour = maxChosedTimeHour + maxChosedTimeMinutes ~/ 60;
          maxChosedTimeMinutes =
              maxChosedTimeMinutes + maxChosedTimeMinutes % 60;
        }
        print(dates);
        print(date);
        var maxExistingTimeHour = slot['hour'];
        var maxExistingTimeMinutes = slot['minute'] + int.parse(session);
        if (maxExistingTimeMinutes > 60) {
          maxExistingTimeHour =
              maxExistingTimeHour + (maxExistingTimeMinutes ~/ 60);
          maxExistingTimeMinutes =
              maxExistingTimeMinutes + maxExistingTimeMinutes % 60;
        }

        var slotChosedStartingMinutes =
            slotchosed['hour'] * 60 + slotchosed['minute'];
        var slotChosedEndingMinutes =
            maxChosedTimeHour * 60 + maxChosedTimeMinutes;

        var existingStartingMinutes = slot['hour'] * 60 + slot['minute'];
        var existingEndingMinutes =
            maxExistingTimeHour * 60 + maxExistingTimeMinutes;
        if (dates == date) {
          print("INSIDE DATES");
          print(existingStartingMinutes.runtimeType);
          print(existingEndingMinutes);
          print(slotChosedStartingMinutes);
          print(slotChosedEndingMinutes);
          if (existingStartingMinutes <= slotChosedStartingMinutes &&
              slotChosedStartingMinutes <= existingEndingMinutes) {
            print("result turned false");
            result = false;
          } else if (slotChosedStartingMinutes <= existingStartingMinutes &&
              existingStartingMinutes <= slotChosedEndingMinutes) {
            result = false;
          }
        }
        // var datas = appointmentsCollectionRef.get().data()![];
      }
      print("RETURNED RESULT");
      print(result);
    }
    return result;
  }

  Future createAppointment({
    String? doctorUid,
    String? patientUid,
    String? consultationFee,
    String? secretCode,
    Map<String, int>? slotChosen,
    Map<dynamic, String>? slotsDetails,
    String? date,
    String? sessionTime,
  }) async {
    var appointmentsCollection =
        FirebaseFirestore.instance.collection("appointments");
    final DocumentReference appointmentDocRef = appointmentsCollection.doc();
    Random random = new Random();
    int randomNumber = random.nextInt(9000) +
        1000; // generates a random number between 1000 and 9999
    secretCode = randomNumber.toString();
    await appointmentDocRef.set({
      'doctorUid': doctorUid,
      'patientUid': patientUid,
      'consultationFee': consultationFee,
      'timeOfBooking': DateTime.now(),
      'slotChosen': slotChosen,
      'sessionTime': sessionTime,
      'date': date,
      'status': 'Booked',
      'code': secretCode,
    });

    String appointmentId = appointmentDocRef.id;
    print(slotChosen);
    slotsDetails![slotChosen!] = appointmentId;
    print(slotsDetails);
    var doctorRef = appointmentsCollection.doc('doctors').collection('doctors');
    final DocumentReference doctorAppointmentDocRef = doctorRef.doc(doctorUid);
    var dateRef = doctorAppointmentDocRef.collection("$date");
    final Map<String, dynamic> serializedSlotsDetails = {};
    slotsDetails.forEach((key, value) {
      if (key != null) {
        serializedSlotsDetails[key.toString()] = value;
      }
    });
    QuerySnapshot snapshot = await dateRef.get();
    if (snapshot.docs.length > 0) {
      String documentId = snapshot.docs[0].id;
      // use the documentId to update the document
      await dateRef.doc(documentId).set({
        'slotsDetails': serializedSlotsDetails,
      });
    } else {
      await dateRef.doc().set({
        'slotsDetails': serializedSlotsDetails,
      });
    }

    print("Uploaded to appointments collection");
    var patientCollection = FirebaseFirestore.instance.collection("users");
    final DocumentReference patientDocRef = patientCollection.doc(patientUid);
    print(patientUid);
    await patientDocRef.update({
      'appointmentId': FieldValue.arrayUnion([appointmentId]),
    });
    print("Uploaded to patient collection");
  }

  Future updateDoctorProfile(
      {String? name,
      String? phone,
      String? email,
      String? qualification,
      String? category,
      String? consultationFee,
      String? aimNumber}) async {
    print("UID is $uid");
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    dynamic complete = false;
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        complete = data['complete'];
        break;
      }
    }
    return await documentRef.set({
      'name': name,
      'email': email,
      'phone': phone,
      'qualification': qualification,
      'category': category,
      'consulationFee': consultationFee,
      'timings': null,
      'aimNumber': aimNumber,
      'verified': false,
      'complete': false,
      'initialised': 'true',
      'userType': 'doctor'
    });
  }

  Future updateDoctorTimings(Map<String, Map<String, dynamic>> schedule,
      String consultationTime) async {
    print("UID is $uid");
    var clinicsCollection = FirebaseFirestore.instance
        .collection("users")
        .where("userType", isEqualTo: "clinic");
    var clinicsQuerySnapshot = await clinicsCollection.get();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot;
    var documentRef;
    var doctorsCollection;
    dynamic complete = false;
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        complete = data['complete'];
        break;
      }
    }
    return await documentRef.update({
      'timings': schedule,
      'verified': true,
      'complete': true,
      'consultationTime': consultationTime,
    });
  }

  Future cancelAppointment(String appointmentId) async {
    final appointmentsRef = FirebaseFirestore.instance
        .collection("appointments")
        .doc(appointmentId);

    await appointmentsRef.update({"status": "cancelled"});
  }

  Future makeInitialisedTrue(String? uid) async {
    final clinicsCollectionRef =
        FirebaseFirestore.instance.collection("users").doc(uid);
    print("CHANGING INITIALISED");
    await clinicsCollectionRef.update({"initialised": "true"});
  }
}
