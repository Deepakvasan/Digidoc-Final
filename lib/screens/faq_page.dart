import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
            child: Text("ABOUT US",
                style: TextStyle(fontSize: 35), textAlign: TextAlign.left)),
        SizedBox(
          height: 20,
        ),
        Container(
            child: Text(
          "Digi doc is your one stop app for all your medical needs. Developed by the students of CEG tech forum it utlizes machine learning and other deep learning techniques to help the functioning of the application.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.left,
        )),
        Container(
            child: Text(
          "Contact info:+91 XXXXXXXXXX",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.left,
        )),
        Container(
            child: Text(
          "Email id:sample@gmail.com",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.left,
        )),
        SizedBox(
          height: 30,
        ),
        Image.asset(
          'assets/depositphotos_6499876-stock-photo-heart-care.jpg',
          height: 100,
          width: 100,
          alignment: Alignment.topLeft,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            child: Text(
          "FAQ",
          style: TextStyle(fontSize: 35),
          textAlign: TextAlign.left,
        )),
        SizedBox(
          height: 20,
        ),
        ExpansionTile(
          title: const Text('hello'),
          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('hi')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
        ExpansionTile(
          title: const Text('hello'),
          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('hi')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
      ],
    );
  }
}
