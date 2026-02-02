// import 'package:device_preview/device_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view_category_page.dart';
import 'package:mini_quiz/pages/user_side/quiz_QCM1.dart';
import 'package:mini_quiz/pages/user_side/quiz_QCM2.dart';
import 'package:mini_quiz/pages/user_side/quiz_multi_answer.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // home: const ViewCategoryScreen(),
      // theme: ThemeData(
      //   fontFamily: 'Fredoka',
      //   textTheme: const TextTheme(
      //     titleLarge: TextStyle(
      //       fontSize: 30,
      //       fontWeight: FontWeight.w900,
      //       letterSpacing: 1.4,
      //     ),
      //     bodyMedium: TextStyle(fontSize: 16),
      //   ),
      // ),
      initialRoute: '/q1',
      routes: {
        '/q1': (context) => const Quiz_QCM1(),
        '/q2': (context) => const Quiz_QCM2(),
        '/q3': (context) => const Multi_answer(),
      },
    );
  }
}
