import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/model/user_model.dart';
import 'package:mini_quiz/services/api_service.dart';
import 'package:mini_quiz/services/local_storage_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var isLoading = false.obs;
  RxBool status = false.obs;
  

  var filteredUsers = <User>[].obs; // filtered list
  var searchText = ''.obs;

  var isEditing = false.obs;
  int? editingUserId;
  var selectedUserId = RxnInt();

  final LocalStorageService localStorageService = LocalStorageService();
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
        users.where(
          (user) =>
              user.email.toLowerCase().contains(value.toLowerCase()) ||
              user.roleId.toString().contains(value),
        ),
      );
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/users');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        users.value = data.map((json) => User.fromJson(json)).toList();

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

  Future<User?> login(String email) async {
    // Check if already loading to prevent double clicks
    if (isLoading.value) return null;

    try {
      isLoading.value = true;

      // Call login endpoint - backend already creates user if doesn't exist
      final response = await ApiService.dio.post(
        '/login',
        data: {'email': email},
      );

      User? user;

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          user = User.fromJson(data);
          
          // Save to local storage
          localStorageService.write('userId', user.userId);
          localStorageService.write('roleId', user.roleId);
          print('User saved to local storage - userId: ${user.userId}, roleId: ${user.roleId}');
        }
      }
      print('user ${user}');
      return user;
    } catch (e) {
      print("Login error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(int userId, String email) async {
    try {
      final response = await ApiService.dio.patch(
        '/user/$userId',
        data: {'email': email},
      );
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
