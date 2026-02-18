
class Question {
  final int questionId;
  final String question;
  final int score;
  final LevelForQuestion level;
  final CategoryForQuestion category;
  

  Question({
    required this.questionId,
    required this.question,
    required this.score,
    required this.level,
    required this.category,
    
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      question: json['question'],
      score: json['score'],
      level: LevelForQuestion.fromJson(json['level']),
      category: CategoryForQuestion.fromJson(json['category']),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question': question,
      'score': score,
      'level': level.toJson(),
      'category': category.toJson(),
      
    };
  }
}
class LevelForQuestion {
  final int levelId;
  final String levelName;
  final String description;
  final DateTime createdAt;

  LevelForQuestion({
    required this.levelId,
    required this.levelName,
    required this.description,
    required this.createdAt,
  });

  factory LevelForQuestion.fromJson(Map<String, dynamic> json) {
    return LevelForQuestion(
      levelId: json['level_id'],
      levelName: json['level_name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'level_name': levelName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
class CategoryForQuestion {
  final int categoryId;
  final String categoryName;
  final String description;
  final DateTime createdAt;

  CategoryForQuestion({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.createdAt,
  });

  factory CategoryForQuestion.fromJson(Map<String, dynamic> json) {
    return CategoryForQuestion(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),

    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
