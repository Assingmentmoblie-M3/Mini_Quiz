import 'dart:async';
import 'package:flutter/material.dart';

class Multi_answer extends StatefulWidget {
  const Multi_answer({super.key});

  @override
  State<Multi_answer> createState() => _MultiAnswerState();
}

class _MultiAnswerState extends State<Multi_answer> {
  Set<int> selectedIndexes = {};

  // ===== TIMER LOGIC =====
  static const int totalSeconds = 60;
  int remainingSeconds = totalSeconds;
  Timer? timer;

  final List<String> options = [
    "Khmer New Year",
    "Water Festival",
    "Pchum Ben",
    "Christmas",
  ];

  final Color primaryGreen = const Color(0xFF19A191);
  final Color borderGreen = const Color(0xFFB2DFDB);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        // ប្តូរទៅកាន់ Screen បន្ទាប់ (/q4) ពេលអស់ម៉ោង
        Navigator.pushNamed(context, '/q4');
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // បិទ timer ពេលចាកចេញពី screen
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
    return Scaffold(
      // backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        // ចំណុចសំខាន់៖ មិនប្រើ Center ដើម្បីឱ្យវា Full Screen
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Title, Time & Step
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quiz #1",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: primaryGreen,
                    ),
                  ),
                  Text(
                    '${formatTime(remainingSeconds)}\n3/5',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Q3.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Which festivals are officially celebrated in Cambodia?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              /// Multi-Select Options (Split UI)
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
                            // ប្រអប់ Checkbox
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
                                  ? Icon(
                                      Icons.check_rounded,
                                      color: currentColor,
                                      size: 30,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // ប្រអប់អត្ថបទ
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: currentColor,
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

              /// Bottom Buttons
              Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      timer?.cancel();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderGreen, width: 2),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: primaryGreen,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Next Button
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: selectedIndexes.isEmpty
                            ? null
                            : () {
                                timer?.cancel();
                                Navigator.pushNamed(context, '/q4');
                              },
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
