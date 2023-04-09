// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// void main() => runApp(const CalendarApp());

// class CalendarApp extends StatelessWidget {
//   const CalendarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Calendar App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CalendarPage(),
//     );
//   }
// }

// class CalendarPage extends StatefulWidget {
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<dynamic>?> _events = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar'),
//       ),
//       body: Column(
//         children: [
//           TableCalendar(
//             calendarFormat: _calendarFormat,
//             focusedDay: _focusedDay,
//             firstDay: DateTime.utc(2021, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             eventLoader: (day) => _events[day] ?? [],
//             availableGestures: AvailableGestures.none,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _events[_selectedDay]?.length ?? 0,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_events[_selectedDay]![index] ?? ''),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton:
//           FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
//     );
//   }
// }
