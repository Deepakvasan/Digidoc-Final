import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:signup_login/screens/doctor_home.dart';
import 'package:signup_login/screens/login_screen.dart';
import 'package:signup_login/services/auth.dart';
import 'package:signup_login/services/database.dart';

class FixTimingsOfDoctor extends StatefulWidget {
  const FixTimingsOfDoctor({super.key});

  @override
  State<FixTimingsOfDoctor> createState() => _FixTimingsOfDoctorState();
}

class _FixTimingsOfDoctorState extends State<FixTimingsOfDoctor> {
  Map<String, int> timeOfDayToMap(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }

  Map<String, Map<String, dynamic>> _schedule = {
    'Monday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Tuesday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Wednesday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Thursday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Friday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Saturday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
    'Sunday': {
      'available': false,
      'start_time': TimeOfDay(hour: 0, minute: 0),
      'end_time': TimeOfDay(hour: 0, minute: 0)
    },
  };
  String? error = "";

  AuthService _auth = AuthService();
  @override
  TimeOfDay? _startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? _endTime = TimeOfDay(hour: 0, minute: 0);
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  bool _mondayChecked = false;
  bool _tuesdayChecked = false;
  bool _wedChecked = false;
  bool _thursdayChecked = false;
  bool _fridayChecked = false;
  bool _saturdayChecked = false;
  bool _sundayChecked = false;

  TextEditingController ConsultationTimeFeeController = TextEditingController();

  Future<TimeOfDay?> _selectStartTime(BuildContext context, String day) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _schedule[day]!['start_time'] = pickedTime;
      });

      return pickedTime;
    }
    return null;
  }

  Future<TimeOfDay?> _selectEndTime(BuildContext context, String day) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (pickedTime != null) {
      setState(() {
        _schedule[day]!['end_time'] = pickedTime;
      });
      return pickedTime;
    }
    return null;
  }

  String _getStartTimeText(String day) {
    if (_schedule[day]!['start_time'] == null) {
      return 'Select time';
    } else {
      return _schedule[day]!['start_time']!.format(context);
    }
  }

  String _getEndTimeText(String day) {
    if (_schedule[day]!['end_time'] == null) {
      return 'Select time';
    } else {
      return _schedule[day]!['end_time']!.format(context);
    }
  }

  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text("${error}"),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Fix your timings"),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: basicFormKey,
                  child: TextFormField(
                      controller: ConsultationTimeFeeController,
                      decoration: const InputDecoration(
                        labelText: "Session Time (in minutes)",
                      ),
                      validator: (value) {
                        RegExp _numeric = RegExp(r'[0-9]?');
                        if (value!.isNotEmpty && _numeric.hasMatch(value)) {
                          return null;
                        } else if (!_numeric.hasMatch(value)) {
                          return "Input should only be numbers";
                        } else {
                          return "Cant be empty";
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monday'),
                    Checkbox(
                      value: _mondayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _mondayChecked = newValue!;
                          _schedule['Monday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Monday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Monday');
                              },
                              child: Text(_getStartTimeText('Monday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Monday');
                              },
                              child: Text(_getEndTimeText('Monday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Monday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Monday')),
                            ),
                          ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tuesday'),
                    Checkbox(
                      value: _tuesdayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _tuesdayChecked = newValue!;
                          _schedule['Tuesday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Tuesday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Tuesday');
                              },
                              child: Text(_getStartTimeText('Tuesday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Tuesday');
                              },
                              child: Text(_getEndTimeText('Tuesday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Tuesday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Tuesday')),
                            ),
                          ]),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Wednesday'),
                      Checkbox(
                        value: _wedChecked,
                        onChanged: (newValue) {
                          setState(() {
                            _wedChecked = newValue!;
                            _schedule['Wednesday']!['available'] = newValue;
                          });
                        },
                      ),
                      _schedule['Wednesday']!['available']
                          ? Row(children: [
                              ElevatedButton(
                                onPressed: () {
                                  _selectStartTime(context, 'Wednesday');
                                },
                                child: Text(_getStartTimeText('Wednesday')),
                              ),
                              Text('-'),
                              ElevatedButton(
                                onPressed: () {
                                  _selectEndTime(context, 'Wednesday');
                                },
                                child: Text(_getEndTimeText('Wednesday')),
                              ),
                            ])
                          : Row(children: [
                              ElevatedButton(
                                onPressed: null,
                                child: Text(_getStartTimeText('Wednesday')),
                              ),
                              Text('-'),
                              ElevatedButton(
                                onPressed: null,
                                child: Text(_getEndTimeText('Wednesday')),
                              ),
                            ]),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Thursday'),
                    Checkbox(
                      value: _thursdayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _thursdayChecked = newValue!;
                          _schedule['Thursday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Thursday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Thursday');
                              },
                              child: Text(_getStartTimeText('Thursday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Thursday');
                              },
                              child: Text(_getEndTimeText('Thursday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Thursday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Thursday')),
                            ),
                          ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Friday'),
                    Checkbox(
                      value: _fridayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _fridayChecked = newValue!;
                          _schedule['Friday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Friday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Friday');
                              },
                              child: Text(_getStartTimeText('Friday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Friday');
                              },
                              child: Text(_getEndTimeText('Friday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Friday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Friday')),
                            ),
                          ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saturday'),
                    Checkbox(
                      value: _saturdayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _saturdayChecked = newValue!;
                          _schedule['Saturday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Saturday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Saturday');
                              },
                              child: Text(_getStartTimeText('Saturday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Saturday');
                              },
                              child: Text(_getEndTimeText('Saturday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Saturday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Saturday')),
                            ),
                          ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sunday'),
                    Checkbox(
                      value: _sundayChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _sundayChecked = newValue!;
                          _schedule['Sunday']!['available'] = newValue;
                        });
                      },
                    ),
                    _schedule['Sunday']!['available']
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectStartTime(context, 'Sunday');
                              },
                              child: Text(_getStartTimeText('Sunday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: () {
                                _selectEndTime(context, 'Sunday');
                              },
                              child: Text(_getEndTimeText('Sunday')),
                            ),
                          ])
                        : Row(children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getStartTimeText('Sunday')),
                            ),
                            Text('-'),
                            ElevatedButton(
                              onPressed: null,
                              child: Text(_getEndTimeText('Sunday')),
                            ),
                          ]),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("${error}"),
                Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(7.73),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                        child: Text("Complete"),
                        padding: EdgeInsets.fromLTRB(6, 19, 6, 19),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (basicFormKey.currentState?.validate() ?? false) {
                            for (var day in _schedule.keys) {
                              if (!_schedule[day]!['available']) {
                                continue;
                              } else {
                                var start = _schedule[day]!['start_time'];

                                var end = _schedule[day]!['end_time'];

                                if (start == null || end == null) {
                                  setState(() {
                                    error = "Timings cant be empty";
                                  });
                                } else if (end.hour < start.hour ||
                                    (end.hour == start.hour &&
                                        end.minute < start.minute)) {
                                  setState(() {
                                    error =
                                        "End timings cant be before start tiimings";
                                    ;
                                  });
                                  print(error);
                                } else if ((end.hour - start.hour) * 60 +
                                        (end.minute - start.minute).abs() <
                                    int.parse(
                                        ConsultationTimeFeeController.text)) {
                                  setState(() {
                                    error =
                                        "Total session timings cant be less than the time for one appointment !";
                                    ;
                                  });
                                  print(error);
                                } else {
                                  _schedule.forEach((key, value) {
                                    print('$key:');
                                    _schedule[key]!['start_time'] =
                                        timeOfDayToMap(
                                            _schedule[key]!['start_time']);
                                    _schedule[key]!['end_time'] =
                                        timeOfDayToMap(
                                            _schedule[key]!['end_time']);
                                    value.forEach((innerKey, innerValue) {
                                      print('  $innerKey: $innerValue');
                                    });
                                  });
                                  // Satisfied
                                  String? uid = _auth.getCurrentUserUid();
                                  DatabaseService _database =
                                      DatabaseService(uid: uid);
                                  try {
                                    await _database
                                        .updateDoctorTimings(_schedule);
                                    print("Pushed to firebase");
                                    setState() {
                                      error = "";
                                    }

                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DoctorHome()));
                                  } catch (e) {
                                    error = e.toString();
                                    print("Here");
                                    print(e.toString());
                                  }
                                }
                              }
                            }
                          } else {
                            print("Cant proceed");
                            error = "Form not validated";
                          }
                        })),
              ],
            ),
          ),
        ));
  }
}
