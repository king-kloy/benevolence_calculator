import 'package:flutter/material.dart';

import 'locator.dart';
import 'src/screens/views/sign_in.dart';

void main() {
  // setup getIt service locator
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color(0xFF5A2215).withOpacity(.1),
    100: Color(0xFF5A2215).withOpacity(.2),
    200: Color(0xFF5A2215).withOpacity(.3),
    300: Color(0xFF5A2215).withOpacity(.4),
    400: Color(0xFF5A2215).withOpacity(.5),
    500: Color(0xFF5A2215).withOpacity(.6),
    600: Color(0xFF5A2215).withOpacity(.7),
    700: Color(0xFF5A2215).withOpacity(.8),
    800: Color(0xFF5A2215).withOpacity(.9),
    900: Color(0xFF5A2215).withOpacity(1),
  };

  final MaterialColor customColor = MaterialColor(0xFFB00606, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benevolence Calculator',
      theme: ThemeData(
        primarySwatch: customColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}
