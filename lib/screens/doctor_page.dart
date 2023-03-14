import 'package:flutter/material.dart';

class DoctorPage extends StatefulWidget {
  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digidoc"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 300,
            padding: EdgeInsets.only(bottom: 5),
            width: double.infinity,
            child: Image.asset(
              'assets/images/doc3.png',
              fit: BoxFit.cover,
            )),
        Container(
          padding: EdgeInsets.only(bottom: 0, left: 10),
          child: Text(
            "Dr.Sandra",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30, left: 10),
          child: Text("Apollo Hospital",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Appointment Timings",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "10:00 AM ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "11:00 AM",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "12:00 PM",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "1:00 PM ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "2:00 PM ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "3:00 PM  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "4:00 PM ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "5:00 PM ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Container(
                    padding: EdgeInsets.all(5),
                    width: 130,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: Text(
                          "6:00 PM  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ],
            )
          ],
        ),
        Container(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child:
                  ElevatedButton(onPressed: () => {}, child: Text("BOOK NOW")),
            ))
      ]),
    );
  }
}
