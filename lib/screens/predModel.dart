// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';

// class PredModel extends StatefulWidget {
//   @override
//   _PredModelState createState() => _PredModelState();
// }

// class _PredModelState extends State<PredModel> {
//   var predValue = "";
//   @override
//   void initState() {
//     super.initState();
//     predValue = "click predict button";
//   }

//   Future<void> predData() async {
//     final interpreter = await Interpreter.fromAsset('model.tflite');
//     var input = [
//       [54, 1, 2, 100, 150, 0, 0, 247, 0, 0.8, 1, 0, 3, 1]
//     ];
//     var output = List.filled(1, 0).reshape([1, 1]);
//     var inputFloats = input.map((list) {
//       return list.map((i) => i.toDouble()).toList();
//     }).toList();
//     var inputTfLite = inputFloats.map((list) {
//       return list.map((d) => Float32List.fromList([d])).toList();
//     }).toList();

//     // print(interpreter.getInputTensors());
//     // print(interpreter.getOutputTensors());
//     // interpreter.invoke();
//     // print(input);
//     // print(output);
//     interpreter.run(inputTfLite, output);
//     print(output);

//     setState(() {
//       predValue = (output[0][0] * 100).toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "change the input values in code to get the prediction",
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 12),
//             MaterialButton(
//               color: Colors.blue,
//               child: Text(
//                 "predict",
//                 style: TextStyle(fontSize: 25),
//               ),
//               onPressed: predData,
//             ),
//             SizedBox(height: 12),
//             Text(
//               "Predicted value :  $predValue %",
//               style: TextStyle(color: Colors.red, fontSize: 23),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
