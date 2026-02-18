import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/levels_page.dart';
import 'package:mini_quiz/pages/admin_side/model/category_model.dart';
import 'package:mini_quiz/pages/admin_side/model/level_model.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';
import 'package:mini_quiz/pages/admin_side/view_level_page.dart';
import 'package:mini_quiz/services/api_service.dart';

class LevelController extends GetxController {
  var levels = <Level>[].obs;
  var isLoading = false.obs;

  var isEditing = false.obs;
  int? editingLevelId;
  var categories = <Category>[].obs;
  var selectedCategoryId = RxnInt();

  var filteredLevels = <Level>[].obs;  // filtered list
  var searchText = ''.obs;

  void startEdit(int id, String name, String description, int categoryId) {
    isEditing.value = true;
    editingLevelId = id;

    levelNameController.text = name;
    descriptionController.text = description;
    selectedCategoryId.value = categoryId;
  }

  void cancelEdit() {
    isEditing.value = false;
    editingLevelId = null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLevels();
    fetchCategories();
  }

  void resetForm() {
    levelNameController.clear();
    descriptionController.clear();
    levelController.selectedCategoryId.value = null;
  }
  void searchLevels(String value) {
    if (value.isEmpty) {
      filteredLevels.assignAll(levels);
    } else {
      filteredLevels.assignAll(
        levels.where((level) => level.levelName.toLowerCase().contains(value.toLowerCase())),
      );
    }
  }
  Future<void> fetchLevels() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/levels');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        levels.value = data.map((json) => Level.fromJson(json)).toList();
        print(response);
      } else {
        Get.snackbar('Error', 'Failed to load levels');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching levels');
    } finally {
      isLoading.value = false;
    }
    filteredLevels.assignAll(levels);
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.dio.get('/categories');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        categories.value = data.map((json) => Category.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  void setCategory(Category category) {
    selectedCategoryId.value = category.categoryId;
  }

  Future<void> addLevel(String name, String description, int categoryId) async {
    try {
      final response = await ApiService.dio.post(
        '/level',
        data: {
          'name': name,
          'description': description,
          'category_id': categoryId,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Level added successfully');
        fetchLevels(); // Refresh the list after adding
      } else {
        Get.snackbar('Error', 'Failed to add level');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding level');
    }
  }

  Future<void> updateLevel(
    int levelId,
    String name,
    String description,
    int categoryId,
  ) async {
    try {
      final response = await ApiService.dio.patch(
        '/level/$levelId',
        data: {
          'name': name,
          'description': description,
          'category_id': categoryId,
        },
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Level updated successfully');
        fetchLevels(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update level');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating level');
    }
  }

  Future<void> deleteLevel(int levelId) async {
    try {
      final response = await ApiService.dio.delete('/level/$levelId');
      print(levelId);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Level deleted successfully');
        fetchLevels(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete level');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting level');
    }
  }
}
