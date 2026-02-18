
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/model/category_model.dart';

class Level {
  final int levelId;
  final String levelName;
  final String description;
  final Category category;
  final DateTime createdAt;
  

  Level({
    required this.levelId,
    required this.levelName,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelId: json['level_id'],
      levelName: json['level_name'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'level_name': levelName,
      'description': description,
      'category': category.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// class CategoryForLevel {
//   final int categoryId;
//   final String categoryName;

//   CategoryForLevel({
//     required this.categoryId,
//     required this.categoryName,
//   });

//   factory CategoryForLevel.fromJson(Map<String, dynamic> json) {
//     return CategoryForLevel(
//       categoryId: json['category_id'],
//       categoryName: json['category_name'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'category_id': categoryId,
//       'category_name': categoryName,
//     };
//   }
// }
