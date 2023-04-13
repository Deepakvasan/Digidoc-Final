import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/screens/patient_home.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointment extends StatefulWidget {
  String? doctorUid = "";
  String? date = "";
  List<dynamic> doctorDetails = [];
  String? patientUid = "";
  dynamic schedule = {};

  BookAppointment({
    super.key,
    required this.date,
    required this.doctorDetails,
    required this.doctorUid,
    required this.patientUid,
    required this.schedule,
  });

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  var appointmentsCollection =
      FirebaseFirestore.instance.collection("appointments");

  DatabaseService _database = DatabaseService();
  Color? _getColor(TimeOfDay slot) {
    return Colors.grey[300];
  }

  Map<String, int>? timeOfDayToMap(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }

  bool _noOtherChoosen(Map<Map<String, int>?, String> slotsChosen) {
    slotChosen =
        slotsChosen.map((key, value) => MapEntry(key, value.toString()));

    slotChosen.forEach((k, v) {
      if (v == "1") {
        slotChosen[k] = "0";
      }
    });
    return true;
  }

  Map<String, int>? _getTimeOfChosenSlot(
      Map<Map<String, int>?, String> slotChosen) {
    Map<String, int>? result = timeOfDayToMap(TimeOfDay(hour: 0, minute: 0));
    slotChosen.forEach((key, value) {
      if (value == "1") {
        result = key;
      }
    });
    return result;
  }

  List<TimeOfDay> slots = [];
  bool slotChosenInitialised = false;
  Map<Map<String, int>?, String> slotChosen = {};
  // Map<Map<String, int>, String> finalSlotChosen ={};
  //this is the map that will be reterieved from the database and pushed into the database.
  Widget _bookSlotWidget(var schedule, String consultationTime) {
    slots = [];
    int slotTime = int.parse(consultationTime); //  minutes

    // Get starting and ending time in minutes
    int startMinutes =
        schedule['start_time']['hour'] * 60 + schedule['start_time']['minute'];
    int endMinutes =
        schedule['end_time']['hour'] * 60 + schedule['end_time']['minute'];

    // Calculate number of slots
    int numSlots = (endMinutes - startMinutes) ~/ slotTime;
    List<Color> containerColors = []; // new list for container colors

    // Divide into slots
    for (int i = 0; i < numSlots; i++) {
      int slotStartMinutes = startMinutes + i * slotTime;
      int slotEndMinutes = slotStartMinutes + slotTime;
      TimeOfDay slotStartTime = TimeOfDay(
          hour: slotStartMinutes ~/ 60, minute: slotStartMinutes % 60);
      TimeOfDay slotEndTime =
          TimeOfDay(hour: slotEndMinutes ~/ 60, minute: slotEndMinutes % 60);
      slots.add(slotStartTime);
      containerColors.add(Colors.grey[300]!); // initialize each color to grey

    }
    print(slots);
    if (!slotChosenInitialised) {
      for (int i = 0; i < slots.length; i++) {
        slotChosen.addAll({timeOfDayToMap(slots[i]): "0"});
        // slotChosen[timeOfDayToMap(slots[i])] = "0";
      }
      slotChosenInitialised = true;
    }

    String? date = widget.date!.split(" ")[0] +
        widget.date!.split(" ")[1] +
        widget.date!.split(" ")[3];
    var doctorRef = appointmentsCollection.doc('doctors').collection('doctors');
    final DocumentReference doctorAppointmentDocRef =
        doctorRef.doc(widget.doctorUid);
    var dateRef = doctorAppointmentDocRef.collection("${date}");
    AuthService _auth = AuthService();
    return FutureBuilder(
        future: dateRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("${snapshot.error}");
              return Text('Error: ${snapshot.error}');
            }

            final querySnapshot = snapshot.data!;
            print("CAME INSIDE INSIDE");
            if (querySnapshot.docs.isEmpty) {
              print("No Documents");
              //retaining the slotChosen to all 0s
            } else {
              slotChosen = querySnapshot.docs[0].get('slots');
              print("TYPE TYPE");
              print(slotChosen.runtimeType);
            }

            print("SLOTS CHOSEN");
            print(slotChosen);
            print(slots);
            List<Map<String, int>?> slot = [];
            for (int i = 0; i < slots.length; i++) {
              slot.add(timeOfDayToMap(slots[i]));
            }

            return Expanded(
              child: ListView(
                children: [
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(slot.length, (index) {
                      // Map<String, int>? slotKey = slot[index];
                      final slotValue = slotChosen[slot[index]];
                      print("SLOT VALUE");
                      print(slot[index]);
                      print(slot[index].runtimeType);

                      print(slotValue);
                      // print(slotChosen.containsKey(slotKey));
                      // print(slotChosen[slotKey]);
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: slotValue != null && slotValue.length > 5
                                ? Colors.red[800]
                                : slotValue == "1"
                                    ? Colors.greenAccent[700]
                                    : Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(
                              slots[index].format(context),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        onTap: slotValue != null && slotValue.length <= 5
                            ? () {
                                print(slots);
                                print(slotChosen);
                                if (_noOtherChoosen(slotChosen)) {
                                  print(slotChosen);
                                  setState(() {
                                    slotChosen[slot[index]] = "1";
                                  });
                                  print("CHANGED ");
                                  print(slotChosen);
                                }
                              }
                            : null,
                      );
                    }),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Book Appointment"),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                actions: [
                  TextButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
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
              body: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _bookAppointmentButton() {
    Map<String, int>? SlotChosed = _getTimeOfChosenSlot(slotChosen);
    String? date = widget.date!.split(" ")[0] +
        widget.date!.split(" ")[1] +
        widget.date!.split(" ")[3];
    print("Date <- this will be a document id" + date);
    return ElevatedButton(
        child: Text("Book Appointment"),
        onPressed: () {
          _database.createAppointment(
            doctorUid: widget.doctorUid,
            patientUid: widget.patientUid,
            consultationFee: widget.doctorDetails[5],
            slotChosen: SlotChosed,
            slotsDetails: slotChosen,
            date: date,
            sessionTime: widget.doctorDetails[8],
          );
          //Now I have to update the necessary things based on slot chosen, doctor uid, patient Uid, consultation fee, time of booking, and then create an appointment and get the appointment id and add it into a field in patients record, and add to the appointmnets collection -> doctor uid -> date -> time slot -> appointment Id.
          //seperately appointment id -> docUid, PatientUid, consultation Fee, Time choosen, session time, feedback, doctor Diagnosis, prescription.
        });
  }

  @override
  Widget build(BuildContext context) {
    var day = widget.date!.split(" ")[2];
    if (day == 'Sun')
      day = "Sunday";
    else if (day == 'Mon')
      day = "Monday";
    else if (day == 'Tue')
      day = "Tuesday";
    else if (day == 'Wed')
      day = "Wednesday";
    else if (day == 'Thu')
      day = "Thursday";
    else if (day == 'Fri')
      day = "Friday";
    else if (day == 'Sat') day = "Saturday";
    print(day);
    var scheduleForDay = widget.schedule["${day}"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${widget.date!.split(" ")[2]}" +
                      " ,${widget.date!.split(" ")[0]} ${widget.date!.split(" ")[1]}" +
                      " ,${widget.date!.split(" ")[3]}",
                  style: TextStyle(
                    fontSize: 28,
                  )),
              SizedBox(height: 25),
              Text("Doctor: Dr. " + "${widget.doctorDetails[0]}",
                  style: TextStyle(fontSize: 20)),
              Text("Consultation Fee: " + "${widget.doctorDetails[5]}",
                  style: TextStyle(fontSize: 20)),
              Text("Category : " + "${widget.doctorDetails[3]}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 25),
              Text("Choose your time slot", style: TextStyle(fontSize: 25)),
              // Text("${scheduleForDay}"),
              Text("${widget.doctorDetails[8]}"),
              _bookSlotWidget(scheduleForDay, widget.doctorDetails[8]),
              _bookAppointmentButton(),
            ],
          )),
    );
  }
}
