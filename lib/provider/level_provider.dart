import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class LevelProvider extends ChangeNotifier {
  List level = [];
  bool isloading = false;
  //fetch from api
  Future<void> fetchLevel() async {
  isloading = true;
  notifyListeners();

  final response = await ApiService.get("levels"); // GET is now valid
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
  Future<bool> deleteLevel(int id) async {
    final response = await ApiService.delete("level", id);
    if (response != null && response['result'] == true) {
      await fetchLevel();
      return true;
    }
    return false;
  }

  Future<bool> updateLevel(
    int id, String name, String description, int? categoryId) async {
  final response = await ApiService.patch("level/$id", {
    "name": name,
    "description": description,
    "category_id": categoryId,
  });

  if (response != null && response['result'] == true) {
    await fetchLevel(); // refresh list
    return true;
  } else {
    print(response?["message"]);
    return false;
  }
}


}
