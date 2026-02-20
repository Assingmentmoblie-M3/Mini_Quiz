import 'dart:convert';
import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class QuestionModel {
  final int questionId;
  final String question;
  final List<String> answers;
  QuestionModel({
    required this.questionId,
    required this.question,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> options = [];

    if (json['answers'] != null && json['answers'].isNotEmpty) {
      final answer = json['answers'][0];
      options = [
        answer['answer_a'] ?? '',
        answer['answer_b'] ?? '',
        answer['answer_c'] ?? '',
        answer['answer_d'] ?? '',
      ];
    }
    return QuestionModel(
      questionId: json['question_id'],
      question: json['question'] ?? '',
      answers: options,
    );
  }
}
class QuizProvider extends ChangeNotifier {
  List<QuestionModel> questions = [];
  bool isLoading = false;

  Future<void> fetchQuestions(int categoryId, int levelId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        "question?category_id=$categoryId&level_id=$levelId",
      );

      if (response != null && response['result'] == true) {
        final List data = response['data'];

        questions = data
            .map((json) => QuestionModel.fromJson(json))
            .toList();
      } else {
        questions = [];
      }
    } catch (e) {
      print("Fetch error: $e");
      questions = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
