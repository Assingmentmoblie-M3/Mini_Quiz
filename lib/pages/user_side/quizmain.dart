import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/user_side/quiz_QCM1.dart';
import 'package:mini_quiz/pages/user_side/quiz_multi_answer.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';
class QuizMainScreen extends StatefulWidget {
  final int categoryId;
  final int levelId;
   final Color themeColor;
  const QuizMainScreen({
    super.key,
    required this.categoryId,
    required this.levelId,
     required this.themeColor,
  });
  @override
  State<QuizMainScreen> createState() => _QuizMainScreenState();
}
class _QuizMainScreenState extends State<QuizMainScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<QuizProvider>().fetchQuestions(
        widget.categoryId,
        widget.levelId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
        elevation: 0,
         leading: IconButton(
           onPressed: () => Navigator.pop(context),
           icon: Icon(CupertinoIcons.chevron_back),
           color: widget.themeColor,
           iconSize: 30,
         ),
       ),
      backgroundColor: Colors.white,
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.questions.isEmpty) {
            return Scaffold(
              body:Container(
                color: Colors.white,
                child:Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          final question = provider.currentQuestion;
          final answers = question['answers'] as List? ?? [];
          if (answers.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(title: const Text("Error")),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Questions ${question['question_id']} No quiz"),
                    ElevatedButton(
                      onPressed: () => provider.nextQuestion(),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            );
          }
          String correctStr =
              (answers[0]['is_correct'] ?? answers[0]['correct_options'] ?? "")
                  .toString();
          if (correctStr.contains(',')) {
            return Multi_answer(themeColor: widget.themeColor,);
          } else {
            return Quiz_QCM1(
              question: question,
              categoryId: widget.categoryId,
              levelId: widget.levelId,
              themeColor: widget.themeColor,
            );
          }
        },
      ),
    );
  }
}
