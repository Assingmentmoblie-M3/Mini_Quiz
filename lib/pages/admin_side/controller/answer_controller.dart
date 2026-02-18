import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/answer_page.dart';
import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:mini_quiz/pages/admin_side/view_question_page.dart';
import 'package:mini_quiz/services/api_service.dart';

class AnswerController extends GetxController {
  var answers = <Answer>[].obs;
  var isLoading = false.obs;

  var isEditing = false.obs;
  int? editingAnswerId;
  var questions = <QuestionForAnswer>[].obs;
  var selectedQuestionId = RxnInt();
  var correctAnswers = <String>[].obs;
  var isMultipleChoice = false.obs;

  void startEdit(
    int id,
    int questionId,
    String answerA,
    String answerB,
    String answerC,
    String answerD,
    String isCorrect,
  ) {
    isEditing.value = true;
    editingAnswerId = id;
    questionController.selectedQuestionId.value = questionId;
    answerAController.text = answerA;
    answerBController.text = answerB;
    answerCController.text = answerC;
    answerDController.text = answerD;
    correctAnswers.value = isCorrect.split(',');
    
     // ✅ now defined
  }
  void resetForm() {
    editingAnswerId = null;
    isEditing.value = false;
    questionController.selectedQuestionId.value = null;
    correctAnswers.clear();
    answerAController.clear();
    answerBController.clear();
    answerCController.clear();
    answerDController.clear();
  }

  void cancelEdit() {
    isEditing.value = false;
    editingAnswerId = null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAnswers();
    fetchQuestions();
  }

  Future<void> fetchAnswers() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/answers');
      if (response.statusCode == 200) {
        print(response);
        final List data = response.data['data'];
        answers.value = data.map((json) => Answer.fromJson(json)).toList();
        // print(data);
      } else {
        Get.snackbar('Error', 'Failed to load answers');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching answers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await ApiService.dio.get('/questions');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        questions.value = data
            .map((json) => QuestionForAnswer.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch questions');
    }
  }

  void setQuestion(QuestionForAnswer question) {
    selectedQuestionId.value = question.questionId;
  }

  Future<void> addAnswer(
    int questionId,
    String answerA,
    String answerB,
    String answerC,
    String answerD,
    String isCorrect,
  ) async {
    try {
      final response = await ApiService.dio.post(
        '/answer',
        data: {
          'question_id': questionId,
          'answer_a': answerA,
          'answer_b': answerB,
          'answer_c': answerC,
          'answer_d': answerD,
          'correct_options': isCorrect,
        },
      );
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Answer added successfully');
        fetchAnswers(); // Refresh the list after adding
      } else {
        Get.snackbar('Error', 'Failed to add answer');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding answer');
    }
  }

  Future<void> updateAnswer(
    int answerId,
    int questionId,
    String answerA,
    String answerB,
    String answerC,
    String answerD,
    String isCorrect,
  ) async {
    try {
      final response = await ApiService.dio.patch(
        '/answer/$answerId',
        data: {
          'question_id': questionId,
          'answer_a': answerA,
          'answer_b': answerB,
          'answer_c': answerC,
          'answer_d': answerD,
          'correct_options': isCorrect,
        },
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Answer updated successfully');
        fetchAnswers(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update answer');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating answer');
    }
  }

  Future<void> deleteAnswer(int answerId) async {
    try {
      final response = await ApiService.dio.delete('/answer/$answerId');
      print(answerId);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Answer deleted successfully');
        fetchAnswers(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete answer');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting answer');
    }
  }
}
