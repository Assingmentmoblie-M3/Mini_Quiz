import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/view/answer_page.dart';
import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:mini_quiz/pages/admin_side/view/view_question_page.dart';
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
        final List data = response.data['data'];
        answers.value = data.map((json) => Answer.fromJson(json)).toList();
        
        print('=== Answers Fetched ===');
        print('Total: ${answers.length}');
        for (var i = 0; i < answers.length; i++) {
          print('Answer $i:');
          print('  - ID: ${answers[i].answerId}');
          print('  - Level ID: ${answers[i].levelId}');
          print('  - Question: ${answers[i].questions?.questionName}');
          print('  - Question Level ID: ${answers[i].questions?.levelId}');
        }
      } else {
        Get.snackbar('Error', 'Failed to load answers');
      }
    } catch (e) {
      print('Error fetching answers: $e');
      Get.snackbar('Error', 'An error occurred while fetching answers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Answer>> fetchAnswersByLevel(int levelId) async {
    try {
      print('╔════════════════════════════════════════╗');
      print('║  Fetching answers for level: $levelId  ║');
      print('╚════════════════════════════════════════╝');
      
      // First, fetch all questions to get level information
      final qResponse = await ApiService.dio.get('/questions');
      if (qResponse.statusCode != 200) {
        print('Failed to fetch questions');
        return [];
      }
      
      final List qData = qResponse.data['data'];
      // Create a map: questionId -> levelId
      final Map<int, int> questionLevelMap = {};
      for (var q in qData) {
        final qId = q['question_id'] as int;
        final levelData = q['level'];
        if (levelData is Map<String, dynamic>) {
          final lId = levelData['level_id'] as int;
          questionLevelMap[qId] = lId;
          print('Question $qId -> Level $lId');
        }
      }
      
      // Fetch all answers
      final aResponse = await ApiService.dio.get('/answers');
      if (aResponse.statusCode != 200) {
        print('Failed to fetch answers');
        return [];
      }
      
      final List aData = aResponse.data['data'];
      final allAnswers = aData.map((json) => Answer.fromJson(json)).toList();
      
      print('\nProcessing ${allAnswers.length} answers...\n');
      final levelAnswers = <Answer>[];
      
      for (var answer in allAnswers) {
        if (answer.questions != null) {
          final qId = answer.questions!.questionId;
          final qLevelId = questionLevelMap[qId];
          
          print('Answer ${answer.answerId}:');
          print('  ├─ Question ID: $qId');
          print('  ├─ Question: ${answer.questions!.questionName}');
          print('  └─ Level: $qLevelId');
          
          if (qLevelId == levelId) {
            // Create new Answer with updated question containing proper levelId
            final updatedQuestion = QuestionForAnswer(
              questionId: answer.questions!.questionId,
              questionName: answer.questions!.questionName,
              levelId: qLevelId,
            );
            
            final updatedAnswer = Answer(
              answerId: answer.answerId,
              questions: updatedQuestion,
              answerA: answer.answerA,
              answerB: answer.answerB,
              answerC: answer.answerC,
              answerD: answer.answerD,
              isCorrect: answer.isCorrect,
              levelId: qLevelId,
            );
            
            levelAnswers.add(updatedAnswer);
            print('     ✓ INCLUDED for level $levelId\n');
          } else {
            print('     ✗ EXCLUDED (not level $levelId)\n');
          }
        }
      }
      
      print('═════════════════════════════════════════');
      print('✓ Result: ${levelAnswers.length} answers for level $levelId');
      print('═════════════════════════════════════════\n');
      
      return levelAnswers;
    } catch (e) {
      print('Error fetching answers for level: $e');
      return [];
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
        
        print('=== Questions Fetched ===');
        print('Total: ${questions.length}');
        for (var i = 0; i < questions.length; i++) {
          print('Question $i:');
          print('  - ID: ${questions[i].questionId}');
          print('  - Name: ${questions[i].questionName}');
          print('  - Level ID: ${questions[i].levelId}');
        }
      }
    } catch (e) {
      print('Error fetching questions: $e');
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
        fetchAnswers(); 
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
