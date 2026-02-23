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
    if (response != null && response['data'] != null) {

      print("DEBUG DATA: ${response['data'][0]}"); 
      List<Map<String, dynamic>> fetchedData = List<Map<String, dynamic>>.from(response['data']);
    
      fetchedData.sort((a, b) => 
        (b['question_id'] ?? 0).compareTo(a['question_id'] ?? 0)
      );

      questions = fetchedData;
    } else {
      questions = [];
    }
  } catch (e) {
    print("LOG: Error fetching questions: $e");
    questions = [];
  }
  isLoading = false;
  notifyListeners();
}
  /*
Future<void> fetchQuestions() async {
  isLoading = true;
  notifyListeners();
  try {
    final response = await ApiService.get("questions");
    print("Full Response: $response");
    if (response != null && response['result'] == true) {
      questions = List<Map<String, dynamic>>.from(response['data']);
      print("Total Questions Loaded: ${questions.length}");
    } else {
      questions = [];
    }
  } catch (e) {
    print("Error fetching questions: $e");
    questions = [];
  }
  isLoading = false;
  notifyListeners();
}*/

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
