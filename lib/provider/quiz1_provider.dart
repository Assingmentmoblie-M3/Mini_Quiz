import 'package:flutter/material.dart';
import '../service/api_fetch.dart';
class QuizProvider extends ChangeNotifier {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  int currentCategoryId = 0;
  int currentLevelId = 0;
  Future fetchQuestions(int categoryId, int levelId) async {
    currentCategoryId = categoryId;
    currentLevelId = levelId;
    currentIndex = 0; 
    score = 0; 
    final response = await ApiService.get(
      "questions?category_id=$categoryId&level_id=$levelId",
    );
    if (response != null && response['result'] == true && response['data'] != null) {
      questions = response['data'];
      notifyListeners();
    }
  }
  Map get currentQuestion => questions.isNotEmpty ? questions[currentIndex] : {};
  bool get isLastQuestion => questions.isNotEmpty && currentIndex == questions.length - 1;
void nextQuestion() {
  if (currentIndex < questions.length - 1) {
    currentIndex++;
    print("ប្តូរទៅសំណួរទី: $currentIndex"); 
    notifyListeners();
  } else {
    print("អស់សំណួរហើយ!");
  }
}

void checkAnswer(List<int> selectedIndexes) {
  List answersList = currentQuestion['answers'] ?? [];
  if (answersList.isEmpty) return;

  var data = answersList[0];

  // ១. ទាញយកចម្លើយត្រូវពី Database ហើយបំបែកជា List (ឧទាហរណ៍: ["A.2", "D.2"])
  String correctStr = (data['correct_options'] ?? data['is_correct'] ?? "").toString();
  List<String> correctValuesFromDB = correctStr
      .split(',')
      .map((e) => e.trim()) 
      .toList();
  List<String> optionsInApp = [
    (data['answer_a'] ?? "").toString().trim(),
    (data['answer_b'] ?? "").toString().trim(),
    (data['answer_c'] ?? "").toString().trim(),
    (data['answer_d'] ?? "").toString().trim(),
  ];
  List<String> userSelectedValues = selectedIndexes
      .map((i) => optionsInApp[i])
      .toList();
  bool isCorrect = false;
  if (userSelectedValues.length == correctValuesFromDB.length) {
    isCorrect = userSelectedValues.every((val) => correctValuesFromDB.contains(val));
  }

  if (isCorrect) {
    score++;
    print(" ត្រឹមត្រូវ! ពិន្ទុបច្ចុប្បន្ន: $score");
  } else {
    print("ខុសហើយ! User រើស: $userSelectedValues | ចម្លើយត្រូវគឺ: $correctValuesFromDB");
  }

  notifyListeners();
}
  void resetQuiz() {
    currentIndex = 0;
    score = 0;
    notifyListeners();
  }
}