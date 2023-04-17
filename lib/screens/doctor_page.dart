import 'package:flutter/material.dart';
import 'package:signup_login/screens/book_appointment.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';
import 'package:intl/intl.dart';

class DoctorPage extends StatefulWidget {
  String DoctorUid = "";
  DoctorPage({
    Key? key,
    required this.DoctorUid,
  }) : super(key: key);
  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  AuthService _auth = AuthService();
  Widget _showListOfDates(var schedule, var docDetails) {
    List<String> dates = [];

    DateTime currentDate = DateTime.now();

    for (int i = 0; i < 8; i++) {
      DateTime nextDate = currentDate.add(Duration(days: i));
      String formattedDate = DateFormat("MMMM d EEEE y").format(nextDate);
      if (schedule["${formattedDate.split(" ")[2]}"]["available"] == true) {
        formattedDate = DateFormat("MMMM d EEE y").format(nextDate);
        dates.add(formattedDate);
      }
    }

    return Flexible(
      child: Container(
          height: MediaQuery.of(context).size.height / 8.5,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff5fc8c8),
                              Color(0xff6ff0f2),
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              dates[index].split(" ")[2],
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              dates[index].split(" ")[0],
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              dates[index].split(" ")[1],
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        print(dates[index]);
                        print(docDetails);
                        print(widget.DoctorUid);
                        print(_auth.getCurrentUserUid());
                        print(schedule);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookAppointment(
                                      date: dates[index],
                                      doctorDetails: docDetails,
                                      doctorUid: widget.DoctorUid,
                                      patientUid: _auth.getCurrentUserUid(),
                                      schedule: schedule,
                                    )));
                      }),
                );
              })),
    );
  }

  Widget _buildScheduleList(var schedule) {
    List<Widget> scheduleWidgets = [];

    // Iterate through each day in the schedule
    schedule.forEach((day, timings) {
      if (timings['available']) {
        // Create a ListTile widget for the day and timings and add it to the list
        scheduleWidgets.add(Row(
          children: [
            Text(day,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 20,
            ),
            Text(
                '${timings['start_time']['hour'].toString().padLeft(2, '0')}:${timings['start_time']['minute'].toString().padLeft(2, '0')} - ${timings['end_time']['hour'].toString().padLeft(2, '0')}:${timings['end_time']['minute'].toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18)),
          ],
        ));
      } else {
        // Create a ListTile widget for the day and add "Unavailable" as the subtitle
        scheduleWidgets.add(Row(
          children: [
            Text(day,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 20,
            ),
            Text(
              "Unavailable",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ));
      }
    });

    // Return the ListView widget with the schedule data
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        children: scheduleWidgets,
      ),
    );
  }

  List<dynamic> docDetails = [];

  Future<List<dynamic>> getDocDetails(String doctorUid) async {
    DatabaseService _database = DatabaseService();
    var doctorDetails = _database.getDoctorDetails(doctorUid);
    return doctorDetails;
  }

  @override
  Widget build(BuildContext context) {
    String? doctorUid = widget.DoctorUid;
    print(DateFormat('yMMMMEEEEd').format(DateTime.now()));

    return FutureBuilder<List<dynamic>>(
        future: getDocDetails(doctorUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            docDetails = snapshot.data!;
            print("From doctors page");
            print(docDetails);
            print(docDetails[6].runtimeType);
            var schedule = docDetails[6];
            return Scaffold(
              appBar: AppBar(
                title: Text("Book Appointment"),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 0, left: 10),
                      child: Text(
                        "Dr. ${docDetails[0]}",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30, left: 10),
                      child: Text("${docDetails[7]}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30, left: 10),
                      child: Text("${docDetails[3]}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Appointment Timings",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    _buildScheduleList(schedule),
                    Text("Book Appointment",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    _showListOfDates(schedule, docDetails),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("${snapshot.error}");
          } else {
            return Scaffold(
                appBar: AppBar(
                  actions: [],
                ),
                body: CircularProgressIndicator());
          }
        });
  }
}
