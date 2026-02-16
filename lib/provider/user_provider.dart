import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class UserProvider extends ChangeNotifier {
  List users = [];
  bool isLoading = false;

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.get("users");
    if (response != null && response['result'] == true) {
      users = response['data'];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addUser({required String email}) async {
    final response = await ApiService.post("user", {"email": email});
    if (response != null && response['result'] == true) {
      await fetchUsers();
      return true;
    }
    return false;
  }

  Future<bool> updateUser({
    required int id,
    required String email,
    required int roleId,
    required int status,
  }) async {
    final response = await ApiService.patch("user/$id", {
      "email": email,
      "role_id": roleId,
      "status": status,
    });
    if (response != null && response['result'] == true) {
      await fetchUsers();
      return true;
    }
    return false;
  }

  Future<bool> deleteUser(int id) async {
    final response = await ApiService.delete("user", id);

    if (response != null && response['result'] == true) {
      await fetchUsers();
      return true;
    }

    return false;
  }
}
