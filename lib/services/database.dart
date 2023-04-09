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
    dynamic name = "";
    dynamic phone = "";
    dynamic category = "";
    dynamic initialised = "";
    dynamic email = "";
    late Map<String, dynamic> data;
    for (final clinic in clinicsQuerySnapshot.docs) {
      doctorsCollection = clinic.reference.collection("doctors");
      documentRef = doctorsCollection.doc(uid);
      docSnapshot = await documentRef.get();
      if (docSnapshot.exists) {
        data = docSnapshot.data() as Map<String, dynamic>;
        name = data['name'];
        phone = data['phone'];
        email = data['email'];
        initialised = data['initialised'];
        category = data['category'];
        break;
      }
    }
    List<dynamic> details = [name, phone, email, category, initialised];
    print("DETAILS ");
    print(details);
    return details;
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

  Future updateDoctorTimings(Map<String, Map<String, dynamic>> schedule) async {
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
    return await documentRef
        .update({'timings': schedule, 'verified': true, 'complete': true});
  }
}
