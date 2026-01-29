import 'dart:async';
import 'package:flutter/material.dart';

class QuizScreen2 extends StatefulWidget {
  const QuizScreen2({super.key});

  @override
  State<QuizScreen2> createState() => _QuizScreen2State();
}

class _QuizScreen2State extends State<QuizScreen2> {
  String? _selectedOption;

  // ===== TIMER =====
  static const int totalSeconds = 60; // 1 minutes
  int remainingSeconds = totalSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        Navigator.pushNamed(context, '/q3'); // auto next question
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
              _header('2/5'),
              const SizedBox(height: 20),
              _questionCard(
                'Q2. What is the national flag color combination of Cambodia?',
              ),
              const SizedBox(height: 24),

              _option('A. Red, White, Blue', 'A'),
              _option('B. Blue, Red, White with Angkor Wat', 'B'),
              _option('C. Green and Yellow', 'C'),
              _option('D. Red and Yellow', 'D'),

              const Spacer(),

              Row(
                children: [
                  _backButton(() {
                    timer?.cancel();
                    Navigator.pop(context);
                  }),
                  const SizedBox(width: 12),
                  Expanded(child: _nextButton()),
                ],
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF19A99A),
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
        color: const Color(0xFF19A99A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _option(String text, String value) {
    final bool isSelected = _selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.green : const Color(0xFFB2DFDB),
            width: 2,
          ),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _backButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB2DFDB), width: 2),
        ),
        child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF19A99A)),
      ),
    );
  }

  Widget _nextButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _selectedOption == null
            ? null
            : () {
                timer?.cancel();
                Navigator.pushNamed(context, '/q3');
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF19A99A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text('Next', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
