import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class QuestionProvider extends ChangeNotifier {
  List questions = [];
  bool isLoading = false;

  Future<void> fetchQuestions() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.get("question");
    if (response != null && response['result'] == true) {
      questions = response['data'];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addQuestion({
    required String question,
    required int score,
    required int categoryId,
    required int levelId,
  }) async {
    final response = await ApiService.post("question", {
      "question": question,
      "score": score,
      "category_id": categoryId,
      "level_id": levelId,
    });
    if (response != null && response['result'] == true) {
      await fetchQuestions();
      return true;
    }
    return false;
  }

  Future<bool> updateQuestion({
    required int id,
    required String question,
    required int score,
    required int categoryId,
    required int levelId,
  }) async {
    final response = await ApiService.patch("question/$id", {
      "question": question,
      "score": score,
      "category_id": categoryId,
      "level_id": levelId,
    });
    if (response != null && response['result'] == true) {
      await fetchQuestions();
      return true;
    }
    return false;
  }

  Future<bool> deleteQuestion(int id) async {
    final response = await ApiService.delete("question" ,id);

    if (response != null && response['result'] == true) {
      await fetchQuestions();
      return true;
    }

    return false;
  }
}
