import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class CategoryModel {
  final int id;
  final String name;
  CategoryModel({required this.id, required this.name});
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['category_id'], name: json['category_name']);
  }
}

class SelectionscreenProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.get("categories");

    if (response != null && response['result'] == true) {
      categories = (response['data'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } else {
      categories = [];
      print(response?['message']);
    }

    isLoading = false;
    notifyListeners();
  }
}
