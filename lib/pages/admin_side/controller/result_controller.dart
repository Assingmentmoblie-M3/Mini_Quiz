import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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

  var sortColumn = "user_id".obs;
var sortDirection = "desc".obs;
// Total Score column index


  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchCategories();
    fetchResults();
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
          'sort_column': sortColumn.value,
          'sort_direction': sortDirection.value,
          "perpage": 10,
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

  // ================= SAVE / DELETE =================
  Future<void> addResult() async {
    if (selectedUserId.value == null || selectedCategoryId.value == null) {
      Get.snackbar("Error", "Select user and category");
      return;
    }
    if (answers.isEmpty) {
      Get.snackbar("Error", "Select at least one answer");
      return;
    }

    try {
      final response = await ApiService.dio.post(
        '/result',
        data: {
          'user_id': selectedUserId.value,
          'category_id': selectedCategoryId.value,
          'answers': answers,
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Result saved");
        resetForm();
        fetchResults();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save result");
    }
  }

  Future<void> deleteResult(int resultId) async {
    try {
      final response = await ApiService.dio.delete('/result/$resultId');
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Result deleted successfully');
        fetchResults();
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting result');
    }
  }
}
