/*import 'package:flutter/cupertino.dart';
import '../service/api_fetch.dart';

class QuizProvider extends ChangeNotifier {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  int currentCategoryId=0;
  int currentLevelId=0;

Future fetchQuestions(int categoryId, int levelId) async {

  currentCategoryId = categoryId;
  currentLevelId = levelId;

  final response = await ApiService.get(
    "questions?category_id=$categoryId&level_id=$levelId",
  );

  if(response != null && response['result']==true){

    questions = response['data'];

    notifyListeners();
  }
}
  Map get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex == questions.length - 1;

void nextQuestion() {
  if (currentIndex < questions.length - 1) {
    currentIndex++;
  }
  notifyListeners();
}
void checkAnswer(List<int> selectedIndexes) {

  final correctList = currentQuestion['correct_options']
      .toString()
      .split(',');

  bool isCorrect = true;

  // Check count
  if (selectedIndexes.length != correctList.length) {
    isCorrect = false;
  }

  if (isCorrect) score++;

  notifyListeners();
}
}*/
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
    score = 0; // Reset ពិន្ទុពេលចាប់ផ្ដើមថ្មី

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
    print("ប្តូរទៅសំណួរទី: $currentIndex"); // សាកល្បង Print មើលក្នុង Console
    notifyListeners(); // 👈 សំខាន់បំផុត គឺអាហ្នឹង ទើប UI ប្តូរ
  } else {
    print("អស់សំណួរហើយ!");
    // អ្នកអាចបន្ថែម Logic ទៅកាន់ Result Screen នៅទីនេះ
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

  // ២. បង្កើតបញ្ជីចម្លើយទាំង ៤ ដែលមានក្នុង App ឱ្យត្រូវតាមលំដាប់ A, B, C, D
  List<String> optionsInApp = [
    (data['answer_a'] ?? "").toString().trim(),
    (data['answer_b'] ?? "").toString().trim(),
    (data['answer_c'] ?? "").toString().trim(),
    (data['answer_d'] ?? "").toString().trim(),
  ];

  // ៣. ទាញយកតម្លៃដែល User បានរើស (ឧទាហរណ៍: User រើស index 0 វានឹងទាញបាន "A.2")
  List<String> userSelectedValues = selectedIndexes
      .map((i) => optionsInApp[i])
      .toList();

  // ៤. ផ្ទៀងផ្ទាត់
  bool isCorrect = false;
  if (userSelectedValues.length == correctValuesFromDB.length) {
    // ឆែកថាគ្រប់តម្លៃដែល user រើស មាននៅក្នុង Database ទាំងអស់
    isCorrect = userSelectedValues.every((val) => correctValuesFromDB.contains(val));
  }

  if (isCorrect) {
    score++;
    print("✅ ត្រឹមត្រូវ! ពិន្ទុបច្ចុប្បន្ន: $score");
  } else {
    print("❌ ខុសហើយ! User រើស: $userSelectedValues | ចម្លើយត្រូវគឺ: $correctValuesFromDB");
  }

  notifyListeners();
}

  void resetQuiz() {
    currentIndex = 0;
    score = 0;
    notifyListeners();
  }
}