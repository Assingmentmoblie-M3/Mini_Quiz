import 'package:mini_quiz/pages/admin_side/model/answer_model.dart';
import 'package:mini_quiz/pages/user_side/model/quiz_question_helper.dart';

List<QuizQuestion> buildQuiz(List<Answer> answers) {
  return answers.map((a) {
    return QuizQuestion(
      questionId: a.questions!.questionId,
      questionText: a.questions!.questionName,
      options: [
        {"key": "A", "value": a.answerA},
        {"key": "B", "value": a.answerB},
        {"key": "C", "value": a.answerC},
        {"key": "D", "value": a.answerD},
      ],
      correctOptions: a.isCorrect.split(','),
    );
  }).toList();
}