import 'package:flutter/material.dart';
import '../service/api_fetch.dart';
class Result {
  final int resultId;
  final int userId;
  final String userEmail;
  final int categoryId;
  final String categoryName;
  final int totalScore;
  final String status;
  final String createdAt;

  Result({
    required this.resultId,
    required this.userId,
    required this.userEmail,
    required this.categoryId,
    required this.categoryName,
    required this.totalScore,
    required this.status,
    required this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultId: json['result_id'],
      userId: json['user_id'],
      userEmail: json['user']?['email'] ?? '',
      categoryId: json['category_id'],
      categoryName: json['category']?['name'] ?? '',
      totalScore: json['total_score'] ?? 0,
      status: json['user']?['status'] == 1 ? 'Active' : 'Inactive',
      createdAt: json['created_at'] ?? '',
    );
  }
}


class ResultProvider extends ChangeNotifier {
  List<Result> results = [];
  bool isLoading = false;

  Future<void> fetchResults() async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.get("results");
    if (response != null && response['result'] == true) {
      results = (response['data'] as List)
          .map((json) => Result.fromJson(json))
          .toList();
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
    final response = await ApiService.delete("result", id);

    if (response != null && response['result'] == true) {
      await fetchResults();
      return true;
    }

    return false;
  }
}
