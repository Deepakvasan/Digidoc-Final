// ignore_for_file: prefer_const_constructors

//import 'package:carousel_pro/carousel_pro.dart';
//import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final List<String> imgList = [
  '.dart_tool/assets/kauvery-2.jpg',
  '.dart_tool/assets/kauvery-5.jpg',
];

class ClinicPageTest extends StatefulWidget {
  const ClinicPageTest({super.key});

  @override
  State<ClinicPageTest> createState() => _ClinicPageTestState();
}

class _ClinicPageTestState extends State<ClinicPageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('DIGIDOC'),
      //   centerTitle: true,
      //   backgroundColor: Color.fromARGB(255, 32, 29, 29),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "CLINIC NAME",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/kauvery-1.webp"),
                      fit: BoxFit.fill,
                      scale: 10.0,
                    ),
                  ),
                ),

                //2nd Image of Slider
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/kauvery-2.jpg"),
                      fit: BoxFit.cover,
                      scale: 10.0,
                    ),
                  ),
                ),

                //3rd Image of Slider
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/kauvery-5.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],

              //Slider Container properties
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
                enlargeFactor: 0.3,
              ),
            ),
            SizedBox(height: 30),
            /*        ElevatedButton(
              onPressed: () => {},
              child: Text('GIVE RATINGS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                //   side: BorderSide(color: Colors.grey, width: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: Colors.grey,
              ),
            ),  */
            RatingBar.builder(
              //  initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Icon(Icons.sentiment_very_dissatisfied,
                        color: Colors.black);
                }
              },
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(height: 10),
            Text(
              'RATINGS: X.Y/5.0',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Icon(Icons.add_location_outlined),
            Text(
              'Location: Kauvery Hospital, Chennai-002',
              style: TextStyle(),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 150),
              child: Container(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'DESCRIPTION:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    //textAlign: TextAlign.center,
                  ),
                  //       'Kauvery Hospital is a multi-specialty Indian hospital chain based in Trichy and Hospitals located in Trichy, Chennai, Hosur, Tirunelveli and Salem, Bengaluru',
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(200, 0, 50, 20),
              child: Text(
                'kauvery Hospital is a multi-specialty Indian hospital chain based in Trichy and Hospitals located in Trichy, Chennai, Hosur, Tirunelveli and Salem, Bengaluru.At Kauvery Hospital our services are designed to provide a very special environment to enhance healing and encompassing the comfort of your home away from home. Our team comprising of International Concierges, Interpreters, Billing Assistance and other associated non-medical staff are all trained to provide assistance efficiently.',
                style: TextStyle(
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          color: Colors.black26,
          child: Text('$index'),
        );
      },
    );
  }
}
