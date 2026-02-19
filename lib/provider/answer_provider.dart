import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class AnswerProvider extends ChangeNotifier {
  List answers = [];
  bool isLoading = false;

  Future<void> fetchAnswers() async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.get("answer");

    if (response != null && response['result'] == true) {
      answers = response['data'];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Map?> getAnswerByQuestion(int questionId) async {
    final response = await ApiService.get("answer/question/$questionId");

    if (response != null && response['result'] == true) {
      return response['data'];
    }

    return null;
  }

  Future<bool> addAnswer({
    required int questionId,
    required String answerA,
    required String answerB,
    required String answerC,
    required String answerD,
    required String correctOption,
  }) async {
    final response = await ApiService.post("answer", {
      "question_id": questionId,
      "answer_a": answerA,
      "answer_b": answerB,
      "answer_c": answerC,
      "answer_d": answerD,
      "correct_option": correctOption,
    });

    if (response != null && response['result'] == true) {
      await fetchAnswers();
      return true;
    }

    return false;
  }

  Future<bool> updateAnswer({
    required int id,
    required String answerA,
    required String answerB,
    required String answerC,
    required String answerD,
    required String correctOption,
  }) async {
    final response = await ApiService.patch("answer/$id", {
      "answer_a": answerA,
      "answer_b": answerB,
      "answer_c": answerC,
      "answer_d": answerD,
      "correct_option": correctOption,
    });

    if (response != null && response['result'] == true) {
      await fetchAnswers();
      return true;
    }

    return false;
  }

  Future<bool> deleteAnswer(int id) async {
    final response = await ApiService.delete("answer", id);

    if (response != null && response['result'] == true) {
      await fetchAnswers();
      return true;
    }

    return false;
  }
}
