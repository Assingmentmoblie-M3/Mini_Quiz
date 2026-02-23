import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';

class Multi_answer extends StatefulWidget {
  const Multi_answer({super.key});
  @override
  State<Multi_answer> createState() => _MultiAnswerState();
}

class _MultiAnswerState extends State<Multi_answer> {
  Set<int> selectedIndexes = {};

  static const int totalSeconds = 60;
  int remainingSeconds = totalSeconds;
  Timer? timer;

  final Color primaryGreen = const Color(0xFF19A191);
  final Color borderGreen = const Color(0xFFB2DFDB);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    remainingSeconds = totalSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
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
    provider.checkAnswer(selectedIndexes.toList());
    if (provider.isLastQuestion) {
      timer?.cancel();
      Navigator.pop(context);
    } else {
      provider.nextQuestion();
      setState(() {
        selectedIndexes.clear();
      });
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
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final currentQ = provider.currentQuestion;
    if (currentQ.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final List answersList = currentQ['answers'] ?? [];
    List options = [];
    if (answersList.isNotEmpty) {
      final data = answersList[0];
      options = [
        data['answer_a'] ?? "",
        data['answer_b'] ?? "",
        data['answer_c'] ?? "",
        data['answer_d'] ?? "",
      ];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Multi-Quiz",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  Text(
                    '${formatTime(remainingSeconds)}\n'
                    '${provider.currentIndex + 1}/${provider.questions.length}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Text(
                  currentQ['question'] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 26),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndexes.contains(index);
                    final Color currentColor = isSelected
                        ? const Color(0xFF00D60B)
                        : const Color(0xFF91E3D9);

                    return GestureDetector(
                      onTap: () => toggleSelection(index),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: currentColor,
                                  width: 2.5,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(Icons.check, color: currentColor)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: currentColor,
                                    width: 2.5,
                                  ),
                                ),
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: selectedIndexes.isEmpty ? null : goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          disabledBackgroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
