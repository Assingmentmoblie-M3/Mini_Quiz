import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/user_side/result.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';

class Quiz_QCM1 extends StatefulWidget {
  final int categoryId;
  final int levelId;
  const Quiz_QCM1({
    super.key,
    required this.categoryId,
    required this.levelId,
    required Map<dynamic, dynamic> question,
  });

  @override
  State<Quiz_QCM1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<Quiz_QCM1> {
  int? selectedIndex;
  Map? question;
  List answers = [];

  static const int totalSeconds = 60;
  int remainingSeconds = totalSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void loadQuestion(QuizProvider provider) {
    if (provider.questions.isNotEmpty) {
      question = provider.currentQuestion;
      if (question!['answers'] != null &&
          (question!['answers'] as List).isNotEmpty) {
        final firstAnswerSet = question!['answers'][0];
        answers = [
          firstAnswerSet['answer_a'] ?? "",
          firstAnswerSet['answer_b'] ?? "",
          firstAnswerSet['answer_c'] ?? "",
          firstAnswerSet['answer_d'] ?? "",
        ];
      } else {
        answers = [];
      }
      setState(() {});
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        goNext();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void goNext() {
    final provider = context.read<QuizProvider>();

    provider.checkAnswer([selectedIndex ?? -1]);

    if (provider.isLastQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPages(
            score: provider.score,
            total: provider.questions.length,
          ),
        ),
      );
    } else {
      provider.nextQuestion();

      selectedIndex = null;
      loadQuestion(provider);

      timer?.cancel();
      remainingSeconds = totalSeconds;
      startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    if (provider.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final question = provider.currentQuestion;
    final answersData = question['answers'][0];

    final List<String> answers = [
      answersData['answer_a'] ?? "",
      answersData['answer_b'] ?? "",
      answersData['answer_c'] ?? "",
      answersData['answer_d'] ?? "",
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20),
              _questionCard(question['question'] ?? ""),
              const SizedBox(height: 24),
              ...List.generate(
                answers.length,
                (index) => _optionTile(
                  text: answers[index],
                  selected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedIndex == null ? null : goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19A191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final provider = context.watch<QuizProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quiz',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF19A191),
          ),
        ),
        Text(
          '${formatTime(remainingSeconds)}\n'
          '${provider.currentIndex + 1}/${provider.questions.length}',
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _questionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF19A191),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _optionTile({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF00D60B) : const Color(0xFFB2DFDB),
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF19A191),
          ),
        ),
      ),
    );
  }
}
