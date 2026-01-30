import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view_answer_page.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  bool isCorrectA = false;
  bool isCorrectB = false;
  bool isCorrectC = false;
  bool isCorrectD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Answers"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(color: Color(0xFF8C8C8C), fontFamily: 'Fredoka'),
                        ),
                        TextSpan(
                          text: 'Answers',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka'
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Answers",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ViewAnswerScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "View Answers",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add Answer",
                            style: TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              
                              labelText: "Select Question",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "q1",
                                child: Text("Question 1"),
                              ),
                              DropdownMenuItem(
                                value: "q2",
                                child: Text("Question 2"),
                              ),
                              DropdownMenuItem(
                                value: "q3",
                                child: Text("Question 3"),
                              ),
                            ],
                            onChanged: (_) {},
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER A
                          AnswerInput(
                            label: "Answer A",
                            isCorrect: isCorrectA,
                            onChanged: (val) =>
                                setState(() => isCorrectA = val!),
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER B
                          AnswerInput(
                            label: "Answer B",
                            isCorrect: isCorrectB,
                            onChanged: (val) =>
                                setState(() => isCorrectB = val!),
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER C
                          AnswerInput(
                            label: "Answer C",
                            isCorrect: isCorrectC,
                            onChanged: (val) =>
                                setState(() => isCorrectC = val!),
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER D
                          AnswerInput(
                            label: "Answer D",
                            isCorrect: isCorrectD,
                            onChanged: (val) =>
                                setState(() => isCorrectD = val!),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              // Save logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007F06),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 20,
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class AnswerInput extends StatelessWidget {
  final String label;
  final bool isCorrect;
  final ValueChanged<bool?> onChanged;

  const AnswerInput({
    super.key,
    required this.label,
    required this.isCorrect,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isCorrect,
          onChanged: onChanged,
          activeColor: const Color(0xFF007F06),
          
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
