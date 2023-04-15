import 'package:flutter/material.dart';

class ClinicCard extends StatelessWidget {
  final String name, rating;

  ClinicCard({
    required this.name,
    required this.rating,
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
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 24.0,
              // backgroundImage: AssetImage("assets/Images/hospital.png"),
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
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff7569b6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text("$rating"),
                      Icon(
                        Icons.star,
                        size: 12.0,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
