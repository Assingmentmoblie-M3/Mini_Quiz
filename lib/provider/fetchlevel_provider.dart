import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class LevelModel {
  final int levelId;
  final String levelName;
  final int? categoryId; // ប្រសិនបើចង់ផ្ទុក category_id
  final String? categoryName;

  LevelModel({
    required this.levelId,
    required this.levelName,
    this.categoryId,
    this.categoryName,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelId: json['level_id'],
      levelName: json['level_name'],
      categoryId: json['category']['id'],
      categoryName: json['category']['name'],
    );
  }
}
class LevelProviders extends ChangeNotifier {
  List<LevelModel> levelList = [];
  bool isLoading = false;

  Future<void> fetchLevels(int categoryId) async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.get("levels?category_id=$categoryId");

    if (response != null && response['result'] == true) {
      levelList = (response['data'] as List)
          .map((e) => LevelModel.fromJson(e))
          .toList();
    } else {
      levelList = [];
    }

    isLoading = false;
    notifyListeners();
  }
}