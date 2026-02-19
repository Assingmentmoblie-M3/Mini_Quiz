import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class CategoryProvider extends ChangeNotifier {
  List categories = [];
  bool isLoading = false;
  //FETCH
  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.get("categories");
    if (response != null && response["result"] == true) {
      categories = response["data"]; // good, just store as-is
    } else {
      categories = [];
      print(response?["message"]);
    }
    isLoading = false;
    notifyListeners();
  }

  //CREATE
  Future<bool> createCategory(String name, String? description) async {
    final response = await ApiService.post("category", {
      "name": name,
      "description": description,
    });
    if (response != null && response["result"] == true) {
      await fetchCategories();
      return true;
    } else {
      print(response?["message"]);
      return false;
    }
  }

  //DELETE
  Future<void> deleteCategory(int id) async {
    final response = await ApiService.delete("category", id);

    if (response != null && response["result"] == true) {
      await fetchCategories();
    } else {
      print(response?["message"]);
    }
  }

  //UPDATE
  Future<bool> updateCategory(
    int categoryId,
    String name,
    String? description,
  ) async {
    final response = await ApiService.patch("category/$categoryId", {
      "name": name,
      "description": description,
    });
    if (response != null && response["result"] == true) {
      await fetchCategories(); // refresh list
      return true;
    } else {
      print(response?["message"]);
      return false;
    }
  }
}
