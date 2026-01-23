import 'package:flutter/material.dart';

class QuizScreen2 extends StatefulWidget {
  const QuizScreen2({super.key});

  @override
  State<QuizScreen2> createState() => _QuizScreen2State();
}

class _QuizScreen2State extends State<QuizScreen2> {
  String? _selectedOption; // Track selected option

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
        Text('2:00\n$step', textAlign: TextAlign.right),
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
          _selectedOption = value; // Update selected option
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
        onPressed: () {
          // You can use _selectedOption here
          if (_selectedOption != null) {
            print('Selected: $_selectedOption');
            // Navigate to next question
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select an option')),
            );
          }
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
