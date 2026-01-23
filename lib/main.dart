import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/category_page.dart';
import 'package:mini_quiz/pages/user_side/quiz_screen1.dart';
import 'package:mini_quiz/pages/user_side/quiz_screen2.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Quiz',
      debugShowCheckedModeBanner: false,
      home: const CategoryScreen(),

      initialRoute: '/q1',
      routes: {
        '/q1': (context) => const QuizScreen1(),
        '/q2': (context) => const QuizScreen2(),
      },
    );
  }
}
