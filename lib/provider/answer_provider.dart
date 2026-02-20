import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class AnswerProvider extends ChangeNotifier {
  List answers = [];
  bool isLoading = false;
  List questions = [];

  // FETCH
  Future<void> fetchAnswers() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.get("answers");
    if (response != null && response["result"] == true) {
      answers = response["data"];
    } else {
      answers = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    final response = await ApiService.get(
      "questions",
    ); // ផ្លូវទៅកាន់ API Questions របស់អ្នក
    if (response != null && response["result"] == true) {
      questions = response["data"];
      notifyListeners();
    }
  }

  // CREATE / UPDATE (ប្រើ Map ដើម្បីផ្ញើទិន្នន័យច្រើន column)
  Future<bool> saveAnswer(Map<String, dynamic> data, {int? id}) async {
    final response = id == null
        ? await ApiService.post("answer", data)
        : await ApiService.patch("answer/$id", data);

    if (response != null && response["result"] == true) {
      await fetchAnswers();
      return true;
    }
    return false;
  }

  // DELETE
  Future<void> deleteAnswer(int id) async {
    final response = await ApiService.delete("answer", id);
    if (response != null && response["result"] == true) {
      await fetchAnswers();
    }
  }

  // សម្រាប់កែប្រែទិន្នន័យ (Update)
  Future<bool> updateAnswer(int id, Map<String, dynamic> data) async {
    final response = await ApiService.patch("answer/$id", data);

    if (response != null && response["result"] == true) {
      await fetchAnswers(); // refresh តារាងឡើងវិញ
      return true;
    } else {
      print("Update Error: ${response?["message"]}");
      return false;
    }
  }
}
