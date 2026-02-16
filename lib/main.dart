// import 'package:device_preview/device_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/LoginScren.dart';
// import 'package:mini_quiz/pages/admin_side/admin_dashboard_page.dart';
// import 'package:mini_quiz/pages/HomeScreen/HomeScreen.dart';
// import 'package:mini_quiz/pages/admin_side/view_category_page.dart';
// import 'package:mini_quiz/pages/admin_side/levels_page.dart';
 void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Fredoka',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.4),
          bodyMedium: TextStyle(fontSize: 16, ),
        ),
      ),
      home:const LoginScreen(),
    );
  }
}
