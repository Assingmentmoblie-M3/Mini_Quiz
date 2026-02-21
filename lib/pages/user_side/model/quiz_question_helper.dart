class QuizQuestion {
  final int questionId;
  final String questionText;
  final List<Map<String, String>> options; 
  final List<String> correctOptions;

  QuizQuestion({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctOptions,
  });
}