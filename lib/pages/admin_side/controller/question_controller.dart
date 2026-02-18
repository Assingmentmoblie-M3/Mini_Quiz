
import 'package:get/get.dart';
// import 'package:mini_quiz/pages/admin_side/model/category_model.dart';
// import 'package:mini_quiz/pages/admin_side/model/level_model.dart';
import 'package:mini_quiz/pages/admin_side/model/question_model.dart';
import 'package:mini_quiz/pages/admin_side/question_page.dart';
import 'package:mini_quiz/services/api_service.dart';

class QuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = false.obs;

  var isEditing = false.obs;
  int? editingQuestionId;

  var categories = <CategoryForQuestion>[].obs;
  var selectedCategoryId = RxnInt();
  var levels = <LevelForQuestion>[].obs;
  var selectedLevelId = RxnInt();
  var selectedQuestionId = RxnInt();

  var filteredQuestions = <Question>[].obs;  // filtered list
  var searchText = ''.obs;
  void setSelectedQuestionId(int? id) {
    selectedQuestionId.value = id;
  }
  void startEdit(int id, String nameQuestion, int score, int categoryId, int levelId) {
    isEditing.value = true;
    editingQuestionId = id;

    nameQuestionController.text = nameQuestion;
    scoreController.text = score.toString();
    selectedLevelId.value = levelId;
    selectedCategoryId.value = categoryId;
  }

  void cancelEdit() {
    isEditing.value = false;
    editingQuestionId = null;
  }

  void resetForm() {
    editingQuestionId = null;
    isEditing.value = false;
    selectedCategoryId.value = null;
    selectedLevelId.value = null;
    nameQuestionController.clear();
    scoreController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
    fetchLevels();
    fetchCategories();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/questions');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        questions.value =
            data.map((json) => Question.fromJson(json)).toList();
            print(data);
      } else {
        Get.snackbar('Error', 'Failed to load questions');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching questions');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.dio.get('/categories');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        categories.value = data.map((json) => CategoryForQuestion.fromJson(json)).toList();
                // print("Categories: ${data}");

      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }
  void setCategory(CategoryForQuestion category) {
    selectedCategoryId.value = category.categoryId;
  }

  void searchQuestions(String value) {
    if (value.isEmpty) {
      filteredQuestions.assignAll(questions);
    } else {
      filteredQuestions.assignAll(
        questions.where((question) => question.question.toLowerCase().contains(value.toLowerCase())
        || question.score.toString().contains(value)),
      );
    }
  }
  Future<void> fetchLevels() async {
    try {
      final response = await ApiService.dio.get('/levels');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        levels.value = data.map((json) => LevelForQuestion.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch levels');
    }
    filteredQuestions.assignAll(questions);
  }
  void setLevel(LevelForQuestion level) {
    selectedLevelId.value = level.levelId;
  }
  Future<void> addQuestion(String nameQuestion, int score, int categoryId, int levelId) async {
    try {
      final response = await ApiService.dio.post('/question', data: {
        'question': nameQuestion,
        'score': score,
        'level_id': levelId,
        'category_id': categoryId,
      });
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Question added successfully');
        fetchQuestions(); // Refresh the list after adding
      } else {
        Get.snackbar('Error', 'Failed to add question');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding question');
    }
  }

  Future <void> updateQuestion(int questionId, String nameQuestion, int score, int categoryId, int levelId) async {
    try {
      final response = await ApiService.dio.patch('/question/$questionId', data: {
        'question': nameQuestion,
        'score': score,
        'level_id': levelId,
        'category_id': categoryId,
      });
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Question updated successfully');
        fetchQuestions(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update question');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating question');
    }
  }
  Future<void> deleteQuestion(int questionId) async {
    try {
      final response = await ApiService.dio.delete('/question/$questionId');
      print(questionId);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Question deleted successfully');
        fetchQuestions(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete question');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting question');
    }
  }

}