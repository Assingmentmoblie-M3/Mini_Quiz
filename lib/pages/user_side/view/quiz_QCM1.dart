import 'dart:async';
import 'package:flutter/material.dart';

class Quiz_QCM1 extends StatefulWidget {
  const Quiz_QCM1({super.key});

  @override
  State<Quiz_QCM1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<Quiz_QCM1> {
  int? selectedIndex;

  // ===== TIMER =====
  static const int totalSeconds = 60; //  change to 1 minute
  int remainingSeconds = totalSeconds;
  Timer? timer;

  final List<String> answers = [
    'A. Yes, I am',
    'B. Yes, I am sure',
    'C. Because I am gay',
    'D. Yes, I am',
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        Navigator.pushNamed(context, '/q2');
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header('1/5'),
              const SizedBox(height: 20),
              _questionCard('Q1. \nWhy are you gay????'),
              const SizedBox(height: 24),

              // Answers
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

              // Next Button
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          timer?.cancel();
                          Navigator.pushNamed(context, '/q2');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19A191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets =====

  Widget _header(String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quiz #1',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF19A191),
          ),
        ),
        Text(
          '${formatTime(remainingSeconds)}\n$step',
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _questionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
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
    // កំណត់ពណ៌បៃតងដែលអ្នកចង់បាន
    final Color primaryGreen = const Color(0xFF19A191);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        // បន្ថែម padding ខាងឆ្វេង (horizontal: 20) ដើម្បីឱ្យអក្សរ A, B, C មើលទៅស្អាត
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF00D60B) // ពណ៌បៃតងភ្លឺពេល Select
                : const Color(0xFFB2DFDB), // ពណ៌បៃតងស្រាលពេលមិនទាន់ Select
            width: 2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }
}
