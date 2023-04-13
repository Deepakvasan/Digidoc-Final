import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup_login/services/auth.dart';
import 'screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/user.dart';
import 'package:signup_login/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      catchError: (_, __) {},
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch:
                buildMaterialColor(Color.fromARGB(200, 20, 204, 204)),
            primaryColorLight:
                buildMaterialColor(Color.fromARGB(200, 15, 244, 244)),
            primaryColor: buildMaterialColor(Color.fromARGB(200, 20, 244, 244)),
            primaryColorDark:
                buildMaterialColor(Color.fromARGB(200, 24, 144, 144)),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: buildMaterialColor(Color.fromARGB(200, 114, 90, 193)),
              secondaryContainer:
                  buildMaterialColor(Color.fromARGB(200, 50, 31, 83)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
            ),
            cardColor: buildMaterialColor(
              Color.fromARGB(1, 7, 58, 188),
            ),
            textTheme: TextTheme()),
        home: const Wrapper(),
      ),
    );
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
