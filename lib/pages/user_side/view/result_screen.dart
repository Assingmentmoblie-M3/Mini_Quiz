import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:mini_quiz/pages/admin_side/model/question_model.dart';
import 'package:mini_quiz/services/local_storage_service.dart';
import 'package:mini_quiz/utill/responsive.dart';

class ResultScreen extends StatefulWidget {
  final int correctScore;
  final int totalScore;
  final List<Answer>? quiz;
  final Map<int, dynamic>? selectedAnswers;
  final Map<int, Question>? questionMap;

  const ResultScreen({
    super.key,
    required this.correctScore,
    required this.totalScore,
    this.quiz,
    this.selectedAnswers,
    this.questionMap,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  LocalStorageService localStorageService = LocalStorageService();
  @override
  void initState() {
   final categoryId = localStorageService.read('categoryId');
    final userId = localStorageService.read('userId');
    print('Category ID: $categoryId, User ID: $userId');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final score = widget.correctScore;
    final total = widget.totalScore;
    final percentage = total > 0 ? ((score / total) * 100).toStringAsFixed(1) : '0.0';

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: CustomScrollView(
        slivers: [
          // Header with score
        SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 250,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Quiz Completed!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A7CA5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Your Score: ",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          TextSpan(
                            text: "$score/$total",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$percentage%",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Details section
          if (widget.quiz != null && widget.selectedAnswers != null && widget.questionMap != null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final answer = widget.quiz![index];
                  final qId = answer.questions?.questionId;
                  if (qId == null) return const SizedBox.shrink();

                  final question = widget.questionMap![qId];
                  if (question == null) return const SizedBox.shrink();

                  final selectedValue = widget.selectedAnswers![qId];
                  final correctKeys = _parseCorrectKeys(answer.isCorrect);
                  final isCorrect = _checkIfCorrect(selectedValue, correctKeys);

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Q${index + 1}: ${answer.questions?.questionName ?? ''}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3A7CA5),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green[100] : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isCorrect ? "✓ Correct" : "✗ Wrong",
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildAnswerDisplay("A", answer.answerA, selectedValue, correctKeys),
                        _buildAnswerDisplay("B", answer.answerB, selectedValue, correctKeys),
                        _buildAnswerDisplay("C", answer.answerC, selectedValue, correctKeys),
                        _buildAnswerDisplay("D", answer.answerD, selectedValue, correctKeys),
                        const SizedBox(height: 8),
                        Text(
                          "Correct Answer(s): ${correctKeys.join(", ")}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        if (selectedValue != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Your Answer: ${_formatSelectedAnswer(selectedValue)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                childCount: widget.quiz?.length ?? 0,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: const Text("No detailed results available"),
                ),
              ),
            ),
          // Continue button at bottom
          SliverPadding(
            padding: const EdgeInsets.all(30),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  
                  // Pop the result screen and the quiz screen to go back to level selection
                  Get.offAllNamed('select_topic_screen');
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerDisplay(String key, String text, dynamic selectedValue, List<String> correctKeys) {
    final isCorrectAnswer = correctKeys.contains(key.toUpperCase());
    final isSelected = _isAnswerSelected(selectedValue, key);
    final isCorrectlySelected = isSelected && isCorrectAnswer;
    final isIncorrectlySelected = isSelected && !isCorrectAnswer;

    Color backgroundColor = Colors.grey[200]!;
    Color textColor = Colors.grey[700]!;

    if (isCorrectAnswer) {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[900]!;
    }
    if (isIncorrectlySelected) {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[900]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrectlySelected
              ? Colors.green
              : isIncorrectlySelected
                  ? Colors.red
                  : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            "$key. ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          ),
          if (isCorrectAnswer)
            const Icon(Icons.check, color: Colors.green, size: 20),
          if (isIncorrectlySelected)
            const Icon(Icons.close, color: Colors.red, size: 20),
        ],
      ),
    );
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
    return uniqueMatches;
  }

  bool _checkIfCorrect(dynamic selectedValue, List<String> correctKeys) {
    if (selectedValue == null || correctKeys.isEmpty) return false;

    if (correctKeys.length > 1) {
      if (selectedValue is Set<String>) {
        final sel = selectedValue.map((s) => s.toUpperCase()).toSet();
        final correctSet = correctKeys.map((s) => s.toUpperCase()).toSet();
        return sel.length == correctSet.length && sel.difference(correctSet).isEmpty;
      }
    } else {
      if (selectedValue is String) {
        return selectedValue.toUpperCase() == correctKeys.first.toUpperCase();
      }
    }
    return false;
  }

  bool _isAnswerSelected(dynamic selectedValue, String key) {
    if (selectedValue == null) return false;

    if (selectedValue is Set<String>) {
      return selectedValue.contains(key.toUpperCase()) || selectedValue.contains(key);
    } else if (selectedValue is String) {
      return selectedValue.toUpperCase() == key.toUpperCase();
    }
    return false;
  }

  String _formatSelectedAnswer(dynamic selectedValue) {
    if (selectedValue is Set<String>) {
      return selectedValue.join(", ");
    } else if (selectedValue is String) {
      return selectedValue;
    }
    return "N/A";
  }
}