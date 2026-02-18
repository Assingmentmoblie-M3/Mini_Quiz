
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/category_page.dart';
import 'package:mini_quiz/pages/admin_side/model/category_model.dart';
import 'package:mini_quiz/services/api_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;

  var isEditing = false.obs;
  int? editingCategoryId;
  var selectedCategoryId = RxnInt();

  var filteredCategories = <Category>[].obs;  // filtered list
  var searchText = ''.obs;

  void startEdit(int id, String name, String description) {
    isEditing.value = true;
    editingCategoryId = id;
  }

  void cancelEdit() {
    isEditing.value = false;
    editingCategoryId = null;
  }
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  void resetForm() {
    categoryNameController.clear();
    descriptionController.clear();
  }
  void setSelectedCategoryId(int? id) {
    selectedCategoryId.value = id;
  }
  void searchCategories(String value) {
    if (value.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where((category) => category.categoryName.toLowerCase().contains(value.toLowerCase())),
      );
    }
  }
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await ApiService.dio.get('/categories');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        categories.value =
            data.map((json) => Category.fromJson(json)).toList();
            // print(data);
      } else {
        Get.snackbar('Error', 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching categories');
    } finally {
      isLoading.value = false;
    }
    filteredCategories.assignAll(categories);
  }

  Future<void> addCategory(String name, String description) async {
    try {
      final response = await ApiService.dio.post('/category', data: {
        'name': name,
        'description': description,
      });
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Category added successfully');
        fetchCategories(); // Refresh the list after adding
      } else {
        Get.snackbar('Error', 'Failed to add category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding category');
    }
  }

  Future <void> updateCategory(int categoryId, String name, String description) async {
    try {
      final response = await ApiService.dio.patch('/category/$categoryId', data: {
        'name': name,
        'description': description,
      });
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Category updated successfully');
        fetchCategories(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating category');
    }
  }
  Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await ApiService.dio.delete('/category/$categoryId');
      print(categoryId);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Category deleted successfully');
        fetchCategories(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting category');
    }
  }

}