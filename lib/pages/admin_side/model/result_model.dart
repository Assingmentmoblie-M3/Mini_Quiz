class Result {
  final int resultId;
  final UserForResult user;
  final CategoryForResult category;
  final int totalScore;

  Result({
    required this.resultId,
    required this.user,
    required this.category,
    required this.totalScore,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultId: json['result_id'] ?? 0,
      user: json['user'] != null
          ? UserForResult.fromJson(json['user'])
          : UserForResult(userId: 0, userEmail: "Unknown"),
      category: json['category'] != null
          ? CategoryForResult.fromJson(json['category'])
          : CategoryForResult(categoryId: 0, categoryName: "Unknown"),
      totalScore: json['total_score'] != null
          ? int.parse(json['total_score'].toString())
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result_id': resultId,
      'user': user.toJson(),
      'category': category.toJson(),
      'total_score': totalScore,
    };
  }
}

class CategoryForResult {
  final int categoryId;
  final String categoryName;

  CategoryForResult({required this.categoryId, required this.categoryName});

  factory CategoryForResult.fromJson(Map<String, dynamic> json) {
    return CategoryForResult(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? "Unknown",
    );
  }
  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'category_name': categoryName};
  }
}

class UserForResult {
  final int userId;
  final String userEmail;

  UserForResult({required this.userId, required this.userEmail});

  factory UserForResult.fromJson(Map<String, dynamic> json) {
    return UserForResult(
      userId: json['user_id'] ?? 0,
      userEmail: json['user_email'] ?? "Unknown",
    );
  }
  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'user_email': userEmail};
  }
}
