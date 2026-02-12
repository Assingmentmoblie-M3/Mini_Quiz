import 'package:flutter/material.dart';
import 'package:mini_quiz/service/api_fetch.dart';

class LevelProvider extends ChangeNotifier {
  List level = [];
  bool isloading = false;
  //fetch from api
  Future<void> fetchLevel() async {
    isloading = true;
    notifyListeners();
    final response = await ApiService.get("level");
    if (response != null && response['result'] == true) {
      level = response['data'];
    } else {
      level = [];
      print(response?['message']);
    }
    isloading = false;
    notifyListeners();
  }

  //create api
  Future<bool> createLevel(
    String? name,
    String? description,
    int? categoryId,
  ) async {
    final response = await ApiService.post("level", {
      "name": name,
      "description": description,
      "category_id": categoryId,
    });
    if (response != null && response['result'] == true) {
      await fetchLevel();
      return true;
    } else {
      print(response?["message"]);
      return false;
    }
  }

  //delete
  Future<void> deleteLevel(int id) async {
    final response = await ApiService.delete("level", id);
    if (response != null && response['result'] == true) {
      await fetchLevel();
    } else {
      print(response?["message"]);
    }
  }

  //upadte
  Future<bool> updateLevel(int levelId, String name, String description) async {
    final response = await ApiService.patch("level/$levelId", {
      "name": name,
      "description": description,
    });
    if (response != null && response['result'] == true) {
      await fetchLevel();
      return true;
    }else{
      print(response?["message"]);
      return false;
    }
  }
}
