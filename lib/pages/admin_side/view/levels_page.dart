import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/controller/level_controller.dart';
import 'package:mini_quiz/pages/admin_side/model/category_model.dart';
import 'package:mini_quiz/pages/admin_side/view/view_level_page.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

final levelNameController = TextEditingController();
final descriptionController = TextEditingController();
final categoryIdController = TextEditingController();

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  Widget build(BuildContext context) {
    final levelController = Get.put(LevelController());
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Levels"),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Home > ",
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Levels",
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Levels
                  const SizedBox(height: 10),
                  const Text(
                    "Levels",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //View Levels
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
                                      const ViewLevelScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
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
                  //box of information
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Levels",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Filed Levels Name
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextField(
                              controller: levelNameController,
                              decoration: InputDecoration(
                                hintText: "Enter levels name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),

                          //Levels
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: "Enter description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          //DropdownButtonForm
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Obx(
                              () => DropdownButtonFormField<int>(
                                value: levelController.selectedCategoryId.value,
                                items: levelController.categories
                                    .map(
                                      (category) => DropdownMenuItem<int>(
                                        value: category.categoryId,
                                        child: Text(category.categoryName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  levelController.selectedCategoryId.value =
                                      value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                hint: const Text('Choose category'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: () {
                                  final name = levelNameController.text.trim();
                                  final description = descriptionController.text
                                      .trim();
                                  final categoryId =
                                      levelController.selectedCategoryId.value;

                                  if (name.isEmpty ||
                                      description.isEmpty ||
                                      categoryId == null) {
                                    Get.snackbar(
                                      'Error',
                                      'Please fill in all fields',
                                    );
                                    return;
                                  }

                                  if (levelController.isEditing.value) {
                                    levelController.updateLevel(
                                      levelController.editingLevelId!,
                                      name,
                                      description,
                                      categoryId,
                                    );
                                  } else {
                                    levelController.addLevel(
                                      name,
                                      description,
                                      categoryId,
                                    );
                                  }

                                  // Reset
                                  levelController.resetForm();
                                  levelController.cancelEdit();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      levelController.isEditing.value
                                      ? Colors.orange
                                      : const Color(0xFF007F06),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                    vertical: 20,
                                  ),
                                ),
                                child: Text(
                                  levelController.isEditing.value
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
