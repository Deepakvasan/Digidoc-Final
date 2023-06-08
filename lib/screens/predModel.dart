// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// class PredModel extends StatefulWidget {
//   // final String inputValues;

//   // PredModel({required this.inputValues});

//   @override
//   _PredModelState createState() => _PredModelState();
// }

// class _PredModelState extends State<PredModel> {
//   var predValue = "";
//   var symptoms = "";
//   @override
//   void initState() {
//     super.initState();
//     // predValue = "click predict button";
//   }

//   Future<void> predData() async {
//     // load model
//     final interpreter = await Interpreter.fromAsset('symptoms.tflite');
//     // custom input
//     // var input = [
//     //   [51.0, 0.0, 2.0, 140.0, 308.0, 0.0, 0.0, 142.0, 0.0, 1.5, 2.0, 1.0, 2.0]
//     // ];
//     var featureNames = {
//       0: '(vertigo) Paroymsal  Positional Vertigo',
//       1: 'AIDS',
//       2: 'Acne',
//       3: 'Alcoholic hepatitis',
//       4: 'Allergy',
//       5: 'Arthritis',
//       6: 'Bronchial Asthma',
//       7: 'Cervical spondylosis',
//       8: 'Chicken pox',
//       9: 'Chronic cholestasis',
//       10: 'Common Cold',
//       11: 'Dengue',
//       12: 'Diabetes ',
//       13: 'Dimorphic hemmorhoids(piles)',
//       14: 'Drug Reaction',
//       15: 'Fungal infection',
//       16: 'GERD',
//       17: 'Gastroenteritis',
//       18: 'Heart attack',
//       19: 'Hepatitis B',
//       20: 'Hepatitis C',
//       21: 'Hepatitis D',
//       22: 'Hepatitis E',
//       23: 'Hypertension ',
//       24: 'Hyperthyroidism',
//       25: 'Hypoglycemia',
//       26: 'Hypothyroidism',
//       27: 'Impetigo',
//       28: 'Jaundice',
//       29: 'Malaria',
//       30: 'Migraine',
//       31: 'Osteoarthristis',
//       32: 'Paralysis (brain hemorrhage)',
//       33: 'Peptic ulcer diseae',
//       34: 'Pneumonia',
//       35: 'Psoriasis',
//       36: 'Tuberculosis',
//       37: 'Typhoid',
//       38: 'Urinary tract infection',
//       39: 'Varicose veins',
//       40: 'hepatitis A'
//     };
//     var input = [
//       [
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         1,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         1,
//         1,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         1,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0,
//         0
//       ]
//     ];

//     // input from the extracted text
//     // var doubleList =
//     //     widget.inputValues.map((str) => double.parse(str)).toList();
//     // var input = [];
//     // input.add(doubleList);
//     // print(input);

//     // input string
//     var featuresMap = {
//       'itching': 0,
//       'skin_rash': 1,
//       'nodal_skin_eruptions': 2,
//       'continuous_sneezing': 3,
//       'shivering': 4,
//       'chills': 5,
//       'joint_pain': 6,
//       'stomach_pain': 7,
//       'acidity': 8,
//       'ulcers_on_tongue': 9,
//       'muscle_wasting': 10,
//       'vomiting': 11,
//       'burning_micturition': 12,
//       'spotting_ urination': 13,
//       'fatigue': 14,
//       'weight_gain': 15,
//       'anxiety': 16,
//       'cold_hands_and_feets': 17,
//       'mood_swings': 18,
//       'weight_loss': 19,
//       'restlessness': 20,
//       'lethargy': 21,
//       'patches_in_throat': 22,
//       'irregular_sugar_level': 23,
//       'cough': 24,
//       'high_fever': 25,
//       'sunken_eyes': 26,
//       'breathlessness': 27,
//       'sweating': 28,
//       'dehydration': 29,
//       'indigestion': 30,
//       'headache': 31,
//       'yellowish_skin': 32,
//       'dark_urine': 33,
//       'nausea': 34,
//       'loss_of_appetite': 35,
//       'pain_behind_the_eyes': 36,
//       'back_pain': 37,
//       'constipation': 38,
//       'abdominal_pain': 39,
//       'diarrhoea': 40,
//       'mild_fever': 41,
//       'yellow_urine': 42,
//       'yellowing_of_eyes': 43,
//       'acute_liver_failure': 44,
//       'fluid_overload': 117,
//       'swelling_of_stomach': 46,
//       'swelled_lymph_nodes': 47,
//       'malaise': 48,
//       'blurred_and_distorted_vision': 49,
//       'phlegm': 50,
//       'throat_irritation': 51,
//       'redness_of_eyes': 52,
//       'sinus_pressure': 53,
//       'runny_nose': 54,
//       'congestion': 55,
//       'chest_pain': 56,
//       'weakness_in_limbs': 57,
//       'fast_heart_rate': 58,
//       'pain_during_bowel_movements': 59,
//       'pain_in_anal_region': 60,
//       'bloody_stool': 61,
//       'irritation_in_anus': 62,
//       'neck_pain': 63,
//       'dizziness': 64,
//       'cramps': 65,
//       'bruising': 66,
//       'obesity': 67,
//       'swollen_legs': 68,
//       'swollen_blood_vessels': 69,
//       'puffy_face_and_eyes': 70,
//       'enlarged_thyroid': 71,
//       'brittle_nails': 72,
//       'swollen_extremeties': 73,
//       'excessive_hunger': 74,
//       'extra_marital_contacts': 75,
//       'drying_and_tingling_lips': 76,
//       'slurred_speech': 77,
//       'knee_pain': 78,
//       'hip_joint_pain': 79,
//       'muscle_weakness': 80,
//       'stiff_neck': 81,
//       'swelling_joints': 82,
//       'movement_stiffness': 83,
//       'spinning_movements': 84,
//       'loss_of_balance': 85,
//       'unsteadiness': 86,
//       'weakness_of_one_body_side': 87,
//       'loss_of_smell': 88,
//       'bladder_discomfort': 89,
//       'foul_smell_of urine': 90,
//       'continuous_feel_of_urine': 91,
//       'passage_of_gases': 92,
//       'internal_itching': 93,
//       'toxic_look_(typhos)': 94,
//       'depression': 95,
//       'irritability': 96,
//       'muscle_pain': 97,
//       'altered_sensorium': 98,
//       'red_spots_over_body': 99,
//       'belly_pain': 100,
//       'abnormal_menstruation': 101,
//       'dischromic _patches': 102,
//       'watering_from_eyes': 103,
//       'increased_appetite': 104,
//       'polyuria': 105,
//       'family_history': 106,
//       'mucoid_sputum': 107,
//       'rusty_sputum': 108,
//       'lack_of_concentration': 109,
//       'visual_disturbances': 110,
//       'receiving_blood_transfusion': 111,
//       'receiving_unsterile_injections': 112,
//       'coma': 113,
//       'stomach_bleeding': 114,
//       'distention_of_abdomen': 115,
//       'history_of_alcohol_consumption': 116,
//       'blood_in_sputum': 118,
//       'prominent_veins_on_calf': 119,
//       'palpitations': 120,
//       'painful_walking': 121,
//       'pus_filled_pimples': 122,
//       'blackheads': 123,
//       'scurring': 124,
//       'skin_peeling': 125,
//       'silver_like_dusting': 126,
//       'small_dents_in_nails': 127,
//       'inflammatory_nails': 128,
//       'blister': 129,
//       'red_sore_around_nose': 130,
//       'yellow_crust_ooze': 131
//     };
//     // var inputString =
//     //     "dischromic _patches,itching,skin_rash,nodal_skin_eruptions";
//     // var inputString = widget.inputValues;
//     var inputString = symptoms;
//     print(symptoms);
//     var inputList = inputString.split(',');
//     // print(inputList);
//     var inputPresentSymptoms = List.filled(132, 0).reshape([1, 132]);
//     for (String inp in inputList) {
//       // print("x" + inp.trim() + "x");
//       inputPresentSymptoms[0][featuresMap[inp.trim()] as int] = 1;
//     }
//     print(inputPresentSymptoms);
//     // output
//     var output = List.filled(82, 0).reshape([2, 41]);
//     // print(output);

//     // some conversions
//     var inputFloats = input.map((list) {
//       return list.map((i) => i.toDouble()).toList();
//     }).toList();
//     // print(inputFloats);
//     var inputTfLite = inputFloats.map((list) {
//       return list.map((d) {
//         return Float32List.fromList([d])[0];
//       }).toList();
//     }).toList();
//     // print(inputTfLite);

//     // run model on the input
//     interpreter.run(inputTfLite, output);
//     var pureOutput = [];
//     // prediction = [np.argmax(i) for i in prediction ]
//     for (List o in output) {
//       var max = -1.0;
//       var maxIndex = 0;
//       for (int i = 0; i < o.length; i++) {
//         if (o[i] > max) {
//           max = o[i];
//           maxIndex = i;
//         }
//       }
//       pureOutput.add(maxIndex);
//     }
//     print(pureOutput);
//     print(predValue);
//     setState(() {
//       predValue = featureNames[pureOutput[0]] as String;
//     });
//     // setState(() {
//     //   var op = output[0][0];
//     //   var opList = [];
//     //   for (List o in output) {
//     //     if (o[0] > 0.5) {
//     //       opList.add(1);
//     //     } else {
//     //       opList.add(0);
//     //     }
//     //   }
//     //   print(opList);
//     //   if (op > 0.5) {
//     //     predValue = "Has heart disease";
//     //   } else {
//     //     predValue = "Has no heart disease";
//     //   }
//     //   // print(predValue);
//     //   // predValue = (output[0][0]).toString();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextFormField(
//                     onChanged: (value) {
//                       setState(() {
//                         predValue = "";
//                         symptoms = value as String;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'Enter the symptoms:',
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   MaterialButton(
//                     color: Colors.green,
//                     child: Text(
//                       "Predict Disease",
//                       style: TextStyle(fontSize: 25),
//                     ),
//                     onPressed: () {
//                       predData();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Text(
//             //   "change the input values in code to get the prediction",
//             //   style: TextStyle(fontSize: 16),
//             // ),
//             // SizedBox(height: 12),
//             // MaterialButton(
//             //   color: Colors.green,
//             //   child: Text(
//             //     "predict",
//             //     style: TextStyle(fontSize: 25),
//             //   ),
//             //   onPressed: predData,
//             // ),
//             SizedBox(height: 12),
//             Text(
//               "Predicted Disease : " + predValue,
//               style: TextStyle(color: Colors.black, fontSize: 23),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
