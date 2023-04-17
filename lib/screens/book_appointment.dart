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

  bool isLoading = false;
  bool freeError = true;
  bool _noOtherChoosen(Map<Map<String, int>?, String> slotsChosen) {
    print(slotsChosen);
    slotChosen =
        slotsChosen.map((key, value) => MapEntry(key, value.toString()));

    slotChosen.forEach((k, v) {
      if (v == "1") {
        slotChosen[k] = "0";
      }
    });
    return true;
  }

  Map<String, int>? _getTimeOfChosenSlot(var sortedMap) {
    Map<String, int>? result = timeOfDayToMap(TimeOfDay(hour: 0, minute: 0));
    sortedMap.forEach((key, value) {
      if (value == "1") {
        result = key;
      }
    });
    return result;
  }

  List<Map<String, int>?> slots = [];
  bool slotChosenInitialised = false;
  bool firstTime = false;

  Map<Map<String, int>?, String> slotChosen = {};
  var slotsChosen;
  List<Color> containerColors = []; // new list for container colors

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

    // Divide into slots
    for (int i = 0; i < numSlots; i++) {
      int slotStartMinutes = startMinutes + i * slotTime;
      int slotEndMinutes = slotStartMinutes + slotTime;
      TimeOfDay slotStartTime = TimeOfDay(
          hour: slotStartMinutes ~/ 60, minute: slotStartMinutes % 60);
      TimeOfDay slotEndTime =
          TimeOfDay(hour: slotEndMinutes ~/ 60, minute: slotEndMinutes % 60);
      slots.add(timeOfDayToMap(slotStartTime));
    }
    print(slots);
    if (!slotChosenInitialised) {
      for (int i = 0; i < slots.length; i++) {
        slotChosen.addAll({slots[i]: "0"});
        containerColors.add(Colors.grey[300]!); // initialize each color to grey

        // slotChosen[timeOfDayToMap(slots[i])] = "0";
      }
      slotChosenInitialised = true;
    }

    String? date = widget.date!.split(" ")[0] +
        "," +
        widget.date!.split(" ")[1] +
        "," +
        widget.date!.split(" ")[3];
    var doctorRef = appointmentsCollection.doc('doctors').collection('doctors');
    final DocumentReference doctorAppointmentDocRef =
        doctorRef.doc(widget.doctorUid);
    var dateRef = doctorAppointmentDocRef.collection("$date");
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
              if (!firstTime) {
                slotChosen = {};
                slotsChosen = querySnapshot.docs[0].get('slotsDetails');
                print("TYPE TYPE");

                slotsChosen.forEach((key, value) {
                  print(key);
                  print(" ");
                  print(value);
                  String hr = key.split(",")[0];
                  hr = hr.split(": ")[1];
                  print(hr);
                  String min = key.split(",")[1];
                  min = min.split(": ")[1];
                  min = min.split("}")[0];
                  print(min);
                  int hour = int.parse(hr);
                  int minute = int.parse(min);
                  print(hour);
                  print(minute);
                  print(value);

                  slotChosen[{'hour': hour, 'minute': minute}] = value;
                });

                print(slotChosen);
                print(slotChosen.runtimeType);
                print(slotsChosen.runtimeType);
                firstTime = true;
              }
            }

            print("SLOTS CHOSEN");
            // print(slotChosen);
            var sortedMap = Map.fromEntries(slotChosen.entries.toList()
              ..sort((a, b) {
                var aHour = a.key!['hour'];
                var bHour = b.key!['hour'];
                var aMinute = a.key!['minute'];
                var bMinute = b.key!['minute'];
                if (aHour == bHour) {
                  return aMinute!.compareTo(bMinute!);
                } else {
                  return aHour!.compareTo(bHour!);
                }
              }));
            print(sortedMap);
            // print(slots);
            // List<Map<String, int>?> slot = [];
            // for (int i = 0; i < slots.length; i++) {
            //   slot.add(slots[i]);
            // }

            return Expanded(
              child: ListView(
                children: [
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(slots.length, (index) {
                      // Map<String, int>? slotKey = slot[index];
                      // slotValue = slotChosen[slot[index]];
                      // print("SLOT VALUE");
                      // print(slotChosen);
                      print("SORTED MAP");
                      print(sortedMap);
                      dynamic ind = sortedMap.keys.elementAt(index);
                      print(ind);
                      var slotValue = sortedMap.values.elementAt(index);
                      // print(slot[index]);
                      // print(slot[index].runtimeType);
                      // var slotValues = slotChosen.values;
                      // var slotKeys = slotChosen.keys;
                      // final slotValue = slotValues.elementAt(index);
                      print("SLOT VALUE");
                      print(slotValue);
                      print(slotValue.runtimeType);

                      // print(slotValue.runtimeType);
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
                              "${slots[index]!['hour']}:${slots[index]!['minute']}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        onTap: slotValue.length <= 2
                            ? () {
                                print("PRESSED");
                                print(slots);
                                print(sortedMap);
                                if (_noOtherChoosen(sortedMap)) {
                                  print(sortedMap);
                                  setState(() {
                                    slotChosen[ind] = "1";
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

  Future<bool> patientFree(var slotChosed, var date, var sessionTime) async {
    DatabaseService _database = DatabaseService();
    bool result = await _database.isPatientFree(slotChosed, date, sessionTime);
    print(result);
    return result;
  }

  Widget _bookAppointmentButton() {
    Map<String, int>? SlotChosed = _getTimeOfChosenSlot(slotChosen);
    String? date = widget.date!.split(" ")[0] +
        "," +
        widget.date!.split(" ")[1] +
        "," +
        widget.date!.split(" ")[3];
    print("Date <- this will be a document id" + date);
    return ElevatedButton(
        child: Text("Book Appointment"),
        onPressed: () async {
          setState(() {
            isLoading = true;
            freeError = false;
          });

          bool isFree =
              await patientFree(SlotChosed, date, widget.doctorDetails[8]);

          if (isFree) {
            print("BOOKING THE APPOINTMENT");
            await _database.createAppointment(
              doctorUid: widget.doctorUid,
              patientUid: widget.patientUid,
              consultationFee: widget.doctorDetails[5],
              slotChosen: SlotChosed,
              slotsDetails: slotChosen,
              date: date,
              sessionTime: widget.doctorDetails[8],
            );
          } else {
            print("no free time");
          }
          setState(() {
            isLoading = false;
            freeError = isFree;
          });
          // if (await patientFree(SlotChosed, date, widget.doctorDetails[8]) ==
          //     true) {}
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
    // freeError = true;
    var scheduleForDay = widget.schedule["${day}"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Padding(
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
                  // Text("${widget.doctorDetails[8]}"),
                  _bookSlotWidget(scheduleForDay, widget.doctorDetails[8]),
                  freeError
                      ? SizedBox(
                          height: 1,
                        )
                      : Text("You have another appointment at this time"),
                  _bookAppointmentButton(),
                ],
              )),
    );
  }
}
