import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';

import '../../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view/view_category_page.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

final categoryNameController = TextEditingController();
final descriptionController = TextEditingController();

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Category"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Category',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Category",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ViewCategoryScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "View Category",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add Category",
                            style: TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: categoryNameController,
                            decoration: InputDecoration(
                              labelText: "Category Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: () {
                                    final name = categoryNameController.text
                                        .trim();
                                    final description = descriptionController
                                        .text
                                        .trim();

                                    if (name.isEmpty || description.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'Please fill in all fields',
                                      );
                                      return;
                                    }

                                    if (categoryController.isEditing.value) {
                                      // UPDATE
                                      categoryController.updateCategory(
                                        categoryController.editingCategoryId!,
                                        name,
                                        description,
                                      );
                                    } else {
                                      // SAVE
                                      categoryController.addCategory(
                                        name,
                                        description,
                                      );
                                    }

                                    // Reset
                                    categoryController.resetForm();
                                    categoryController.cancelEdit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        categoryController.isEditing.value
                                        ? Colors.orange
                                        : const Color(0xFF007F06),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 100,
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Text(
                                    categoryController.isEditing.value
                                        ? "Update"
                                        : "Save",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
