import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/controller/question_controller.dart';
import 'package:mini_quiz/pages/admin_side/model/question_model.dart';
import 'package:mini_quiz/pages/admin_side/view/view_question_page.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

// final questionController = Get.put(QuestionController());
final nameQuestionController = TextEditingController();
final scoreController = TextEditingController();

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Questions"),
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
                          text: "Home > ",
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Questions",
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Questions",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ViewQuestionScreen(),
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
                        "View Questions",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
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
                            "Add Questions",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextField(
                              controller: nameQuestionController,
                              decoration: InputDecoration(
                                hintText: "Enter question",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextField(
                              controller: scoreController,
                              decoration: InputDecoration(
                                hintText: "Enter score",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Obx(
                              () => DropdownButtonFormField<int>(
                                value: questionController.selectedCategoryId.value,
                                items: questionController.categories
                                    .map(
                                      (category) => DropdownMenuItem<int>(
                                        value: category.categoryId,
                                        child: Text(category.categoryName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  questionController.selectedCategoryId.value = value;
                                  // reset selected level when category changes
                                  questionController.selectedLevelId.value = null;
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
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Obx(
                              () => DropdownButtonFormField<int>(
                                value: questionController.selectedLevelId.value,
                                items: (() {
                                  final selectedCat = questionController.selectedCategoryId.value;
                                  final filtered = selectedCat == null
                                      ? <LevelForQuestion>[]
                                      : questionController.levels
                                          .where((l) => l.categoryId == selectedCat)
                                          .toList();
                                  return filtered
                                      .map(
                                        (level) => DropdownMenuItem<int>(
                                          value: level.levelId,
                                          child: Text(level.levelName),
                                        ),
                                      )
                                      .toList();
                                })(),
                                onChanged: (value) {
                                  questionController.selectedLevelId.value = value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                hint: const Text('Choose level (select category first)'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                final nameQuestion = nameQuestionController.text.trim();
                                final score = scoreController.text.trim();
                                final categoryId = questionController.selectedCategoryId.value;
                                final levelId = questionController.selectedLevelId.value;

                                if (nameQuestion.isEmpty ||
                                    score.isEmpty ||
                                     categoryId == null ||
                                    levelId == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill in all fields',
                                  );
                                  return;
                                }

                                if (questionController.isEditing.value) {
                                  questionController.updateQuestion(
                                    questionController.editingQuestionId!,
                                    nameQuestion,
                                    int.parse(score),
                                    categoryId,
                                    levelId,
                                  );
                                } else {
                                  questionController.addQuestion(
                                    nameQuestion,
                                    int.parse(score),
                                    categoryId,
                                    levelId,
                                  );
                                  
                                }
                                // Reset fields
                                questionController.resetForm();
                                questionController.cancelEdit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: questionController.isEditing.value
                                    ? Colors.orange
                                    : const Color(0xFF007F06),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 20,
                                ),
                              ),
                              child: Text(
                                questionController.isEditing.value ? "Update" : "Save",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
