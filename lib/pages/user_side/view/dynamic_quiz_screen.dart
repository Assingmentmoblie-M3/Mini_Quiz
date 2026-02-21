import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_quiz/pages/admin_side/controller/result_controller.dart';
import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/question_controller.dart';
import 'package:mini_quiz/pages/admin_side/model/question_model.dart';
import 'package:mini_quiz/pages/user_side/view/result_screen.dart';

class DynamicQuizPage extends StatefulWidget {
  final List<Answer> answers;
  final int? levelId;

  const DynamicQuizPage({
    super.key, 
    required this.answers,
    this.levelId,
  });

  @override
  State<DynamicQuizPage> createState() => _DynamicQuizPageState();
}

class _DynamicQuizPageState extends State<DynamicQuizPage> {

  int currentIndex = 0;
  Map<int, dynamic> selectedAnswers = {};

  late List<Answer> quiz;
  
  // Timer functionality
  static const int totalSeconds = 300; // 5 minutes per question
  int remainingSeconds = totalSeconds;
  Timer? timer;
  
  static const Color primaryGreen = Color(0xFF19A191);

  @override
  void initState() {
    super.initState();
    quiz = widget.answers;
    startTimer();
    
    // Show toast message with question count
    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${quiz.length} question${quiz.length > 1 ? 's' : ''} loaded for this level'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
    
    // Debug output
    print('╔════════════════════════════════════════╗');
    print('║  DynamicQuizPage Initialized           ║');
    print('╚════════════════════════════════════════╝');
    print('Level ID: ${widget.levelId}');
    print('Total questions received: ${quiz.length}');
    print('');
    for (var i = 0; i < quiz.length; i++) {
      print('Question ${i + 1}:');
      print('  ├─ Answer ID: ${quiz[i].answerId}');
      print('  ├─ Level ID: ${quiz[i].levelId}');
      print('  ├─ Question ID: ${quiz[i].questions?.questionId}');
      print('  ├─ Question Text: ${quiz[i].questions?.questionName}');
      print('  ├─ Question Level ID: ${quiz[i].questions?.levelId}');
      print('  ├─ Is Correct: ${quiz[i].isCorrect}');
      print('  └─ Is Multi: ${isMulti(quiz[i])}');
    }
    print('');
  }
  
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        next();
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

  bool isMulti(Answer answer) {
    return answer.isCorrect.split(',').length > 1;
  }

  void next() {
    if (currentIndex < quiz.length - 1) {
      setState(() => currentIndex++);
    } else {
      submit();
    }
  }

  void previous() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  void submit() {
    timer?.cancel();

    try {
      final qc = Get.isRegistered<QuestionController>() ? Get.find<QuestionController>() : Get.put(QuestionController());
      final questions = qc.questions;
      final Map<int, Question> qmap = {for (var q in questions) q.questionId: q};

      int totalPossible = 0;
      int correctSum = 0;

      for (var a in quiz) {
        final qId = a.questions?.questionId;
        if (qId == null) continue;
        final question = qmap[qId];
        if (question == null) continue;

        totalPossible += question.score;

        // parse correct keys from a.isCorrect
        final correctKeys = _parseCorrectKeys(a.isCorrect);
        
        print('Q$qId: isCorrect="${a.isCorrect}" -> correctKeys=$correctKeys, isSingleAnswer=${correctKeys.length == 1}');

        if (correctKeys.isEmpty) continue;

        final selectedValue = selectedAnswers[qId];
        if (selectedValue == null) continue;

        if (correctKeys.length > 1) {
          // multi-answer
          if (selectedValue is Set<String>) {
            final sel = selectedValue.map((s) => s.toUpperCase()).toSet();
            final correctSet = correctKeys.map((s) => s.toUpperCase()).toSet();
            if (sel.length == correctSet.length && sel.difference(correctSet).isEmpty) {
              correctSum += question.score;
            }
          }
        } else {
          // single-answer
          if (selectedValue is String) {
            if (selectedValue.toUpperCase() == correctKeys.first.toUpperCase()) {
              correctSum += question.score;
            }
          }
        }
      }

      // Update admin-side result counter (UI only) if controller exists
      try {
        if (Get.isRegistered<ResultController>()) {
          final rc = Get.find<ResultController>();
          rc.totalQuizzes.value = rc.totalQuizzes.value + 1;
        }
      } catch (_) {}

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctScore: correctSum,
            totalScore: totalPossible,
            quiz: quiz,
            selectedAnswers: selectedAnswers,
            questionMap: qmap,
          ),
        ),
      );
    } catch (e) {
      print('Error computing score: $e');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(correctScore: 0, totalScore: 0),
        ),
      );
    }
  }

  List<String> _parseCorrectKeys(String s) {
    if (s.isEmpty) return [];
    
    final up = s.toUpperCase().trim();
    
    // Try to extract answer keys more intelligently
    // First, check if it's a simple letter answer (A, B, C, D)
    List<String> matches = [];
    
    // Match patterns like "A", "AB", "A,B", "A and B", etc.
    // Look for letters A-D that are isolated or part of delimited lists
    final wordBoundaryMatches = RegExp(r'(?:^|[\s,;and\|]+)([A-D])(?=[\s,;and\|]|$)')
        .allMatches(up)
        .map((m) => m.group(1)!)
        .toList();
    
    if (wordBoundaryMatches.isNotEmpty) {
      matches = wordBoundaryMatches;
    } else {
      // Fallback: get all A-D letters if no word boundary matches found
      matches = RegExp(r'[A-D]')
          .allMatches(up)
          .map((m) => m.group(0)!)
          .toList();
    }
    
    // Remove duplicates and sort
    final uniqueMatches = matches.toSet().toList()..sort();
    print('DEBUG: isCorrect="$s" -> parsed keys=$uniqueMatches (all regex matches: $matches)');
    return uniqueMatches;
  }

  @override
  Widget build(BuildContext context) {

    if (quiz.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No questions available'),
        ),
      );
    }

    final answer = quiz[currentIndex];
    final question = answer.questions;
    
    if (question == null) {
      return Scaffold(
        body: Center(
          child: Text('Question not found'),
        ),
      );
    }

    final multi = isMulti(answer);
    final total = quiz.length;
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == total - 1;
    final onlyOne = total == 1;

    final options = [
      {"key": "A", "value": answer.answerA},
      {"key": "B", "value": answer.answerB},
      {"key": "C", "value": answer.answerC},
      {"key": "D", "value": answer.answerD},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader('${currentIndex + 1}/$total'),
              const SizedBox(height: 20),
              _buildQuestionCard(question.questionName),
              const SizedBox(height: 24),

              // OPTIONS
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (_, index) {
                    final option = options[index];
                    final key = option["key"]!;
                    final value = option["value"]!;

                    if (multi) {
                      return _buildMultiOptionTile(
                        question.questionId,
                        key,
                        '$key. $value',
                      );
                    } else {
                      return _buildSingleOptionTile(
                        question.questionId,
                        key,
                        '$key. $value',
                      );
                    }
                  },
                ),
              ),

              // BUTTONS
              _buildButtonSection(onlyOne, isFirst, isLast),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSingleOption(int qId, String key, String text) {

    final selected = selectedAnswers[qId] == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswers[qId] = key;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildSingleOptionTile(int qId, String key, String text) {
    final selected = selectedAnswers[qId] == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswers[qId] = key;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF00D60B)
                : const Color(0xFFB2DFDB),
            width: 2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget buildMultiOption(int qId, String key, String text) {

    selectedAnswers.putIfAbsent(qId, () => <String>{});
    Set<String> set = selectedAnswers[qId];

    final selected = set.contains(key);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            set.remove(key);
          } else {
            set.add(key);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildMultiOptionTile(int qId, String key, String text) {
    selectedAnswers.putIfAbsent(qId, () => <String>{});
    Set<String> set = selectedAnswers[qId];

    final isSelected = set.contains(key);
    final Color currentColor = isSelected
        ? const Color(0xFF00D60B)
        : const Color(0xFF91E3D9);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            set.remove(key);
          } else {
            set.add(key);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Checkbox Container
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
            // Text Container
            Expanded(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: currentColor,
                    width: 2.5,
                  ),
                ),
                child: Text(
                  text,
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
  }

  Widget buildButtons(int total) {

    final isFirst = currentIndex == 0;
    final isLast = currentIndex == total - 1;
    final onlyOne = total == 1;

    return Row(
      children: [

        if (!isFirst)
          IconButton(
            onPressed: previous,
            icon: const Icon(Icons.arrow_back),
          ),

        Expanded(
          child: ElevatedButton(
            onPressed: next,
            child: Text(
              onlyOne
                  ? "Submit"
                  : isLast
                      ? "Submit"
                      : "Next",
            ),
          ),
        ),
      ],
    );
  }

  // ===== Styled Helper Widgets =====

  Widget _buildHeader(String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quiz',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
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

  Widget _buildQuestionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: primaryGreen,
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

  Widget _buildButtonSection(bool onlyOne, bool isFirst, bool isLast) {
    // Check if current question has selections
    final answer = quiz[currentIndex];
    final question = answer.questions;
    final multi = isMulti(answer);
    
    bool hasSelection = false;
    if (multi) {
      final set = selectedAnswers[question?.questionId] as Set<String>?;
      hasSelection = set != null && set.isNotEmpty;
    } else {
      hasSelection = selectedAnswers[question?.questionId] != null;
    }

    return Row(
      children: [
        if (!isFirst)
          // Back Button
          GestureDetector(
            onTap: previous,
            child: Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFB2DFDB),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryGreen,
                size: 20,
              ),
            ),
          ),
        if (!isFirst) const SizedBox(width: 16),
        // Next/Submit Button
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: hasSelection ? next : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(
                onlyOne
                    ? "Submit"
                    : isLast
                        ? "Submit"
                        : "Next",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}