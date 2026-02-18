class Answer {
  final int answerId;
  final QuestionForAnswer? questions;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String isCorrect;

  Answer({
    required this.answerId,
    this.questions,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.isCorrect,
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
    };
  }
}
class QuestionForAnswer {
  final int questionId;
  final String questionName;
  

  QuestionForAnswer({
    required this.questionId,
    required this.questionName,
    
  });

  factory QuestionForAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionForAnswer(
      questionId: json['question_id'],
      questionName: json['question_name'],
      
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_name': questionName,
      
    };
  }
}
