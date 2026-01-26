
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
//import 'package:mini_quiz/pages/admin_side/category_page.dart';
import 'package:mini_quiz/pages/user_side/test.dart';

void main() {
runApp(DevicePreview(builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      home: const LevelPage(),
    );
  }
}
