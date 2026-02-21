import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/user_side/quiz_QCM1.dart';
import 'package:mini_quiz/pages/user_side/quiz_multi_answer.dart' hide Quiz_QCM1;
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';

class QuizMainScreen extends StatefulWidget {
  final int categoryId;
  final int levelId;

  const QuizMainScreen({
    super.key,
    required this.categoryId,
    required this.levelId,
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
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final question = provider.currentQuestion;
        final answers = question['answers'] as List? ?? []; // បន្ថែម null check
        if (answers.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Questions ${question['question_id']} No answers found"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.isLastQuestion) {
                        Navigator.pop(context);
                      } else {
                        provider.nextQuestion();
                      }
                    },
                    child: Text(
                      provider.isLastQuestion ? "Finish" : "Next Question",
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (answers.isEmpty) {
          return Scaffold(
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
        // ឆែកមើលចម្លើយត្រូវក្នុង Database
        String correctStr =
            (answers[0]['is_correct'] ?? answers[0]['correct_options'] ?? "")
                .toString();

        // ✅ បើមានសញ្ញាក្បៀស (ឧទាហរណ៍: "A.4,B.3") ឱ្យទៅ Screen ជ្រើសរើសបានច្រើន
        if (correctStr.contains(',')) {
          return Multi_answer(question: question);
        } else {
          // ✅ បើគ្មានសញ្ញាក្បៀស ឱ្យទៅ Screen ជ្រើសរើសបានតែ១
          return Quiz_QCM1(
            question: question,
            categoryId: widget.categoryId,
            levelId: widget.levelId,
          );
        }
      },
    );
  }
}
