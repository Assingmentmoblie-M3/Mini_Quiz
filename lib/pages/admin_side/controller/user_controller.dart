
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/model/user_model.dart';
import 'package:mini_quiz/services/api_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var isLoading = false.obs;
  RxBool status = false.obs;
  RxInt totalQuizzes = 0.obs;

  var filteredUsers = <User>[].obs;  // filtered list
  var searchText = ''.obs;

  var isEditing = false.obs;
  int? editingUserId;
  var selectedUserId = RxnInt();
  void startEdit(int id, String email) {
    isEditing.value = true;
    editingUserId = id;
  }

  void cancelEdit() {
    isEditing.value = false;
    editingUserId = null;
  }
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
  void setSelectedUserId(int? id) {
    selectedUserId.value = id;
  }
  void searchUsers(String value) {
    if (value.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where((user) =>
            user.email.toLowerCase().contains(value.toLowerCase()) ||
            user.roleId.toString().contains(value)),
      );
    }
  }
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/users');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        users.value =
            data.map((json) => User.fromJson(json)).toList();
            
            // print(data);
      } else {
        Get.snackbar('Error', 'Failed to load users');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching users');
    } finally {
      isLoading.value = false;
    }
    filteredUsers.assignAll(users);
  }

  Future<void> addUser(String email) async {
    try {
      final response = await ApiService.dio.post('/user', data: {
        'email': email,
      });
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'User added successfully');
        fetchUsers(); // Refresh the list after adding
      } else {
        Get.snackbar('Error', 'Failed to add user');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding user');
    }
  }

  Future <void> updateUser(int userId, String email) async {
    try {
      final response = await ApiService.dio.patch('/user/$userId', data: {
        'email': email,
        
      });
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User updated successfully');
        fetchUsers(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update user');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating user');
    }
  }
  Future<void> deleteUser(int userId) async {
    try {
      final response = await ApiService.dio.delete('/user/$userId');
      print(userId);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User deleted successfully');
        fetchUsers(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete user');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting user');
    }
  }

}