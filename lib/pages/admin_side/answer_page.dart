/*import '../../layout/admin_sidebar.dart';
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
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Answers',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
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
                                      ViewAnswerScreen(),
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
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
}*/

import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view_answer_page.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:mini_quiz/provider/answer_provider.dart';

class AnswerScreen extends StatefulWidget {
  final Map? editData;
  final bool isCopy;

  const AnswerScreen({
    super.key,
    this.editData,
    this.isCopy = false,
  });

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _dController = TextEditingController();
  String? _selectedQuestionId;

  bool isCorrectA = false;
  bool isCorrectB = false;
  bool isCorrectC = false;
  bool isCorrectD = false;

  @override
  void initState() {
    super.initState();
    
    // ១. ទាញទិន្នន័យសំណួរមកបង្ហាញក្នុង Dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnswerProvider>(context, listen: false).fetchQuestions();
    });

    // ២. ប្រសិនបើជា Edit ឬ Copy ត្រូវបំពេញទិន្នន័យចូលក្នុង Field
    if (widget.editData != null) {
      _selectedQuestionId = widget.editData!['question_id'].toString();
      _aController.text = widget.editData!['answer_a'] ?? "";
      _bController.text = widget.editData!['answer_b'] ?? "";
      _cController.text = widget.editData!['answer_c'] ?? "";
      _dController.text = widget.editData!['answer_d'] ?? "";

      String correct = widget.editData!['correct_options'] ?? "";
      isCorrectA = correct.contains(_aController.text) && _aController.text.isNotEmpty;
      isCorrectB = correct.contains(_bController.text) && _bController.text.isNotEmpty;
      isCorrectC = correct.contains(_cController.text) && _cController.text.isNotEmpty;
      isCorrectD = correct.contains(_dController.text) && _dController.text.isNotEmpty;
    }
  }

  void _handleSave() async {
   final provider = Provider.of<AnswerProvider>(context, listen: false);

    if (_selectedQuestionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a question")));
      return;
    }

    List<String> correctAnswers = [];
    if (isCorrectA) correctAnswers.add(_aController.text);
    if (isCorrectB) correctAnswers.add(_bController.text);
    if (isCorrectC) correctAnswers.add(_cController.text);
    if (isCorrectD) correctAnswers.add(_dController.text);

    Map<String, dynamic> data = {
      "question_id": _selectedQuestionId,
      "answer_a": _aController.text,
      "answer_b": _bController.text,
      "answer_c": _cController.text,
      "answer_d": _dController.text,
      "correct_options": correctAnswers.join(", "),
    };

    bool success;
    // បើ isCopy = true គឺឱ្យវាហៅ CREATE (មិនបោះ ID ឱ្យទេ)
    if (widget.editData != null && !widget.isCopy) {
      success = await provider.saveAnswer(data, id: widget.editData!['answer_id']);
    } else {
      success = await provider.saveAnswer(data);
    }

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.editData != null && !widget.isCopy ? "Updated Successfully" : "Saved Successfully")),
      );
      Navigator.pop(context);
    }
  }

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
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Answers',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
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
                                      ViewAnswerScreen(),
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
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.editData != null ? (widget.isCopy ? "Copy Answer" : "Edit Answer") : "Add Answer",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        // Dropdown ទាញចេញពី Provider
                        Consumer<AnswerProvider>(
                          builder: (context, provider, child) {
                            return DropdownButtonFormField<String>(
                              value: _selectedQuestionId,
                              hint: const Text("Select Question"),
                              decoration: InputDecoration(
                                labelText: "Choose Question",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: provider.questions.map((q) {
                                return DropdownMenuItem<String>(
                                  value: q['question_id'].toString(),
                                  child: Text("${q['question_id']}. ${q['question'] ?? q['title']}"),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedQuestionId = val),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        AnswerInput(label: "Answer A", controller: _aController, isCorrect: isCorrectA, onChanged: (val) => setState(() => isCorrectA = val!)),
                        const SizedBox(height: 15),
                        AnswerInput(label: "Answer B", controller: _bController, isCorrect: isCorrectB, onChanged: (val) => setState(() => isCorrectB = val!)),
                        const SizedBox(height: 15),
                        AnswerInput(label: "Answer C", controller: _cController, isCorrect: isCorrectC, onChanged: (val) => setState(() => isCorrectC = val!)),
                        const SizedBox(height: 15),
                        AnswerInput(label: "Answer D", controller: _dController, isCorrect: isCorrectD, onChanged: (val) => setState(() => isCorrectD = val!)),
                        
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007F06),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: Text(
                              widget.editData != null && !widget.isCopy ? "Update Answer" : "Save Answer",
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
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
  final TextEditingController controller;
  final ValueChanged<bool?> onChanged;

  const AnswerInput({
    super.key,
    required this.label,
    required this.isCorrect,
    required this.controller,
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
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}