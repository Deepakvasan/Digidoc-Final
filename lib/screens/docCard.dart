import 'package:flutter/material.dart';

class DocCard extends StatelessWidget {
  final String name, designation, qualification;

  DocCard({
    required this.designation,
    required this.name,
    required this.qualification,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundImage: AssetImage("assets/Images/man.png"),
            ),
            Column(
              children: [
                Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$designation",
                      style: TextStyle(fontSize: 13.0),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                        color: Color(0xff7569b6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text("$qualification"),
                          Icon(
                            Icons.star,
                            size: 12.0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
