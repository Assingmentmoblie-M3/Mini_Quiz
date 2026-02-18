class Category {
  final int categoryId;
  final String categoryName;
  final String description;
  final DateTime createdAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.createdAt,
  });

//key in resource
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
