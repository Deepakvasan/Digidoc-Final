import 'package:flutter/material.dart';
import 'package:signup_login/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  AuthService _auth = AuthService();
  String clinicName = '';
  String uid = '';
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.getCurrentUserUid();
    CollectionReference clinicRef =
        FirebaseFirestore.instance.collection('users');
    DocumentReference clinicDocRef = clinicRef.doc(uid);
    CollectionReference doctorsRef = clinicDocRef.collection('doctors');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text("Add Doctors"),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColorDark,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: doctorsRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Column(
                children: [
                  // Text('Welcome, ${clinicName}. \nPlease Add your doctors'),
                  ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map((doc) => ListTile(
                              title: Text(doc['name']),
                              subtitle: Text(doc['email']),
                              trailing: Text(doc['phone']),
                            ))
                        .toList(),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Doctor'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () async {
                      await doctorsRef.add({
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                      });

                      _nameController.clear();
                      _emailController.clear();
                      _phoneController.clear();

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
