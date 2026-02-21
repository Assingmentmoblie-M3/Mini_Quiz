class Answer {
  final int answerId;
  final QuestionForAnswer? questions;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String isCorrect;
  final int? levelId;

  Answer({
    required this.answerId,
    this.questions,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.isCorrect,
    this.levelId,
  });
factory Answer.fromJson(Map<String, dynamic> json) {
  return Answer(
    answerId: json['answer_id'] ?? 0,
    questions: json['question'] is Map<String, dynamic>
        ? QuestionForAnswer.fromJson(json['question'])
        : null,
    answerA: json['answer_a'] ?? '',
    answerB: json['answer_b'] ?? '',
    answerC: json['answer_c'] ?? '',
    answerD: json['answer_d'] ?? '',
    isCorrect: json['is_correct'] ?? '',
    levelId: json['level_id'] ?? (json['level'] is Map<String, dynamic> ? json['level']['level_id'] : null),
  );
}



  Map<String, dynamic> toJson() {
    return {
      'answer_id': answerId,
      'question': questions?.toJson() ?? null,
      'answer_a': answerA,
      'answer_b': answerB,
      'answer_c': answerC,
      'answer_d': answerD,
      'is_correct': isCorrect,
      'level_id': levelId,
    };
  }
}
class QuestionForAnswer {
  final int questionId;
  final String questionName;
  final int? levelId;

  QuestionForAnswer({
    required this.questionId,
    required this.questionName,
    this.levelId,
  });

  factory QuestionForAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionForAnswer(
      questionId: json['question_id'] ?? 0,
      questionName: json['question_name'] ?? '',
      levelId: json['level'] is Map<String, dynamic>
          ? json['level']['level_id']
          : json['level_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_name': questionName,
      'level_id': levelId,
    };
  }
}