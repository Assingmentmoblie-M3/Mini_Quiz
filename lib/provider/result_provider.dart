import 'package:flutter/material.dart';
import '../service//api_fetch.dart';

class ResultProvider extends ChangeNotifier {
  List results = [];
  bool isLoading = false;

  Future<void> fetchResults() async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.get("result");

    if (response != null && response['result'] == true) {
      results = response['data'];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addResult({
    required int userId,
    required int categoryId,
    required int totalScore,
  }) async {
    final response = await ApiService.post("result", {
      "user_id": userId,
      "category_id": categoryId,
      "total_score": totalScore,
    });

    if (response != null && response['result'] == true) {
      await fetchResults();
      return true;
    }

    return false;
  }

  Future<bool> deleteResult(int id) async {
    final response = await ApiService.delete("result" ,id);

    if (response != null && response['result'] == true) {
      await fetchResults();
      return true;
    }

    return false;
  }
}
