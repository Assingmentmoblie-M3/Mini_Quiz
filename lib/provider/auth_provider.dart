import 'package:flutter/material.dart';
import '../service/api_fetch.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  int? roleId;
  String? email;
  Future<bool> login(String emailInput) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.post("auth/login", {
        "email": emailInput,
      });
      if (response["result"] == true) {
        email = response["data"]["email"];
        roleId = response["data"]["role_id"];
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool get isAdmin => roleId == 1;
  bool get isUser => roleId == 0;
}
