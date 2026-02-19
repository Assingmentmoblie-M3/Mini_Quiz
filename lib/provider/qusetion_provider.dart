import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class QuestionProvider extends ChangeNotifier {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = false;
  Future<void> fetchQuestions() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get("questions");
      print("Fetch Questions Response: $response");
      if (response != null && response['result'] == true) {
        questions = List<Map<String, dynamic>>.from(response['data']);
      } else {
        questions = [];
      }
    } catch (e) {
      print("Error fetching questions: $e");
      questions = [];
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
    try {
      final response = await ApiService.post("question", {
        "question": question,
        "score": score,
        "category_id": categoryId,
        "level_id": levelId,
      });

      if (response != null && response['result'] == true) {
        await fetchQuestions(); // refresh list
        return true;
      }
    } catch (e) {
      print("Error adding question: $e");
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
    try {
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
    } catch (e) {
      print("Error updating question: $e");
    }
    return false;
  }

  Future<bool> deleteQuestion(int id) async {
    try {
      final response = await ApiService.delete("question", id);
      if (response != null && response['result'] == true) {
        await fetchQuestions();
        return true;
      }
    } catch (e) {
      print("Error deleting question: $e");
    }
    return false;
  }
}
