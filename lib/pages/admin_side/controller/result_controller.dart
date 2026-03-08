import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:mini_quiz/pages/user_side/view/result_screen.dart';
import 'package:mini_quiz/services/api_service.dart';
import '../model/result_model.dart';
import '../model/category_model.dart';
import '../model/question_model.dart';

class ResultController extends GetxController {
  var results = <Result>[].obs;
  var users = <UserForResult>[].obs;
  var categories = <CategoryForResult>[].obs;
  var questions = <Question>[].obs;

  var selectedUserId = RxnInt();
  var selectedCategoryId = RxnInt();

  var answers = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var isEditing = false.obs;

  int? editingResultId;
  var search = "".obs;

  var totalScoreController = TextEditingController();

  var column = "total_score".obs;
  var sortDirection = "desc".obs;

  RxInt totalQuizzes = 0.obs;
  var filteredUsers = <UserForResult>[].obs; // filtered list
  var searchText = ''.obs;

  RxDouble totalAvgScore = 0.0.obs;

  // Total Score column index

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchCategories();
    fetchResults();
    fetchTotalQuizzes();
    fetchTotalAvgScore();
    countTheMostCategory();
    Timer.periodic(Duration(seconds: 5), (timer) {
      fetchResults();
    });
  }

  // ================= EDIT / RESET =================
  void startEdit(Result result) {
    isEditing.value = true;
    editingResultId = result.resultId;
    selectedUserId.value = result.user.userId;
    selectedCategoryId.value = result.category.categoryId;
    totalScoreController.text = result.totalScore.toString();
    answers.clear();
  }

  void cancelEdit() {
    isEditing.value = false;
    editingResultId = null;
    totalScoreController.clear();
    selectedUserId.value = null;
    selectedCategoryId.value = null;
    answers.clear();
  }

  void resetForm() {
    cancelEdit();
    questions.clear();
  }

  // ================= FETCH DATA =================
  Future<void> fetchResults() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get(
        '/results',
        queryParameters: {
          'search': search.value,
          'column': column.value,
          'sort': sortDirection.value,
          'per_page': 30,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        results.value = data.map((e) => Result.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTotalQuizzes() async {
    final response = await ApiService.dio.get('/results');
    final List data = response.data['data'];
    totalQuizzes.value = data.length;
  }

  Future<void> fetchTotalAvgScore() async {
    final response = await ApiService.dio.get('/results');
    final List data = response.data['data'];
    totalAvgScore.value =
        data.map((e) => e['total_score']).reduce((a, b) => a + b) / data.length;
  }

  Future<void> fetchUsers() async {
    final response = await ApiService.dio.get('/users');
    final List data = response.data['data'];
    users.value = data.map((e) => UserForResult.fromJson(e)).toList();
  }

  Future<void> fetchCategories() async {
    final response = await ApiService.dio.get('/categories');
    final List data = response.data['data'];
    categories.value = data.map((e) => CategoryForResult.fromJson(e)).toList();
  }

  Future<void> fetchQuestionsByCategory(int categoryId) async {
    answers.clear();
    final response = await ApiService.dio.get('/questions/$categoryId');
    final List data = response.data['data'];
    questions.value = data.map((e) => Question.fromJson(e)).toList();
  }

  // ================= ANSWER LOGIC =================
  void toggleOption(int questionId, int optionId) {
    final index = answers.indexWhere((a) => a['question_id'] == questionId);

    if (index == -1) {
      answers.add({
        "question_id": questionId,
        "selected_options": [optionId],
      });
    } else {
      List selected = answers[index]['selected_options'];
      if (selected.contains(optionId)) {
        selected.remove(optionId);
      } else {
        selected.add(optionId);
      }
      answers[index]['selected_options'] = selected;
      answers.refresh();
    }
  }

  bool isOptionSelected(int questionId, int optionId) {
    final answer = answers.firstWhereOrNull(
      (a) => a['question_id'] == questionId,
    );
    if (answer == null) return false;
    return answer['selected_options'].contains(optionId);
  }

  Future<void> saveResult(int userId, int categoryId, int totalScore) async {
    try {
      isLoading.value = true;
      print(
        'Saving result... userId: $userId, categoryId: $categoryId, totalScore: $totalScore',
      );

      final response = await ApiService.dio.post(
        '/save-result',
        data: {
          "user_id": userId,
          "category_id": categoryId,
          "total_score": totalScore,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Get.snackbar('Success', 'Result saved successfully');
        //fetchResults(); // Refresh results list
      } else {
        Get.snackbar(
          'Error',
          'Failed to save result - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error saving result: $e');
      Get.snackbar('Error', 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  final theMostCategory = ''.obs;
  final theMostCategoryUsed = ''.obs;
  Future<void> countTheMostCategory() async {
  final response = await ApiService.dio.get('/results');
  final List data = response.data['data'];

  if (data.isEmpty) return;

  final uniquePairs = <String>{};
  final categoryNames = <int, String>{};

  for (final item in data) {
    final user = item['user'];
    final category = item['category'];

    if (user == null || category == null) continue;

    final int userId = user['user_id'];
    final int categoryId = category['category_id'];
    final String categoryName = category['category_name'];

    uniquePairs.add('$userId-$categoryId');
    categoryNames[categoryId] = categoryName;
  }

  final countMap = <int, int>{};

  for (final pair in uniquePairs) {
    final parts = pair.split('-');
    final int categoryId = int.parse(parts[1]);

    countMap[categoryId] = (countMap[categoryId] ?? 0) + 1;
  }

  if (countMap.isEmpty) return;

  // 🔥 find max value
  final maxCount = countMap.values.reduce((a, b) => a > b ? a : b);

  // 🔥 get all categories with that max value
  final mostCategories = countMap.entries
      .where((entry) => entry.value == maxCount)
      .toList();

  // 🔥 convert ids → names
  final names = mostCategories
      .map((e) => categoryNames[e.key])
      .whereType<String>()
      .toList();

  print("Most used categories: $names");
  print("Unique users: $maxCount");

  theMostCategory.value = names.join(', ');
  theMostCategoryUsed.value = maxCount.toString();
}
}
