import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/HomeScreen.dart';
import 'package:mini_quiz/provider/answer_provider.dart';
import 'package:mini_quiz/provider/auth_provider.dart';
import 'package:mini_quiz/provider/category_provider.dart';
import 'package:mini_quiz/provider/fetchlevel_provider.dart';
import 'package:mini_quiz/provider/level_provider.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:mini_quiz/provider/qusetion_provider.dart';
import 'package:mini_quiz/provider/result_provider.dart';
import 'package:mini_quiz/provider/selectionScreen_provider.dart';
import 'package:mini_quiz/provider/user_provider.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(DevicePreview(builder: (_) => const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ChangeNotifierProvider(create: (_)=> CategoryProvider()),
        ChangeNotifierProvider(create: (_)=> LevelProvider()),
        ChangeNotifierProvider(create: (_)=> QuestionProvider()),
        ChangeNotifierProvider(create: (_)=> AnswerProvider()),
        ChangeNotifierProvider(create: (_)=> UserProvider()),
        ChangeNotifierProvider(create: (_)=> ResultProvider()),
        //selection topic form database
        ChangeNotifierProvider(create: (_) => SelectionscreenProvider()),
        ChangeNotifierProvider(create: (_) => LevelProviders()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Fredoka',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: Homescreen(),
    ),
    );

  }
}
