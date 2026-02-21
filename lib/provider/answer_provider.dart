import 'package:flutter/material.dart';
import '../service/api_fetch.dart';
class AnswerProvider extends ChangeNotifier {
  List answers = [];
  bool isLoading = false;
  List questions = [];
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
  Future<void> deleteAnswer(int id) async {
    final response = await ApiService.delete("answer", id);
    if (response != null && response["result"] == true) {
      await fetchAnswers();
    }
  }
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