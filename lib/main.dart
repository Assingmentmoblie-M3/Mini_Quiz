// import 'package:device_preview/device_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_quiz/pages/admin_side/view/answer_page.dart';
import 'package:mini_quiz/pages/admin_side/view/category_page.dart';
import 'package:mini_quiz/pages/admin_side/view/levels_page.dart';
import 'package:mini_quiz/pages/admin_side/view/question_page.dart';
import 'package:mini_quiz/pages/admin_side/view/user_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_answer_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_category_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_level_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_question_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_result_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_user_page.dart';
import 'package:mini_quiz/pages/user_side/view/dynamic_quiz_screen.dart';
import 'package:mini_quiz/pages/user_side/view/level_screen.dart';
import 'package:mini_quiz/pages/user_side/view/login_screen.dart';
import 'package:mini_quiz/pages/user_side/view/result_screen.dart';
import 'package:mini_quiz/pages/user_side/view/select_topic_screen.dart';
import 'package:mini_quiz/pages/admin_side/view/admin_dashboard_page.dart';
import 'package:mini_quiz/pages/user_side/view/home_screen.dart';
import 'package:mini_quiz/pages/user_side/view/quiz_QCM1.dart';
import 'package:mini_quiz/pages/user_side/view/quiz_QCM2.dart';
import 'package:mini_quiz/pages/user_side/view/quiz_multi_answer.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
 
void main() async {
  setUrlStrategy(PathUrlStrategy());
   WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   fontFamily: 'Fredoka',
      //   textTheme: const TextTheme(
      //     titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.4),
      //     bodyMedium: TextStyle(fontSize: 16, ),
        
      //   ),
      // ),
      //  home: const DashboardScreen(),
      // home: const Homescreen(),

      // home: const ViewCategoryScreen(),
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
      initialRoute: '/login',
      // If the browser requests an unknown path (e.g. on refresh),
      // redirect to the selection screen instead of showing an error
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => SelectionScreen(),
      ),
  routes: {
    '/': (context) =>SelectionScreen(),
    '/home': (context) => const Homescreen(),
    '/login': (context) => const LoginScreen(),

    '/dashboard': (context) => const DashboardScreen(),
    '/category_page': (context) => const CategoryScreen(),
    '/view_category_page': (context) => const ViewCategoryScreen(),
    '/level_page': (context) => const LevelsScreen(),
    '/view_level_page': (context) => const ViewLevelScreen(),
    '/question_page': (context) => const QuestionScreen(),
    '/view_question_page': (context) => const ViewQuestionScreen(),
    '/answer_page': (context) => const AnswerScreen(),
    '/view_answer_page': (context) => const ViewAnswerScreen(),
    '/user_page': (context) => const UserScreen(),
    '/view_user_page': (context) => const ViewUserScreen(),
    '/view_result_page': (context) => ViewResultScreen(),

    '/select_topic_screen': (context) => SelectionScreen(),
    // '/q1': (context) => const Quiz_QCM1(),
    // '/q2': (context) => const Quiz_QCM2(),
    // '/q3': (context) => const Multi_answer(),
    '/level_screen': (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      int categoryId = 1;
      if (args is Map<String, dynamic>) {
        categoryId = args['categoryId'] ?? 1;
      }
      return LevelPage(categoryId: categoryId);
    },
    // '/question_screen': (context) => const DynamicQuizPage(levelId: 1), // Example categoryId
    '/result_screen': (context) =>
      (ModalRoute.of(context)?.settings.arguments is Map<String, dynamic>)
        ? ResultScreen(
          correctScore: (ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>)['correct'] ?? 0,
          totalScore: (ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>)['total'] ?? 0,
          )
        : ResultScreen(correctScore: 0, totalScore: 0),
  },
    );
  }
}
