import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_quiz/pages/admin_side/controller/answer_controller.dart';
import 'package:mini_quiz/pages/admin_side/controller/question_controller.dart';

import '../../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view/view_answer_page.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

final answerAController = TextEditingController();
final answerBController = TextEditingController();
final answerCController = TextEditingController();
final answerDController = TextEditingController();

// final isCorrectA = false.obs;
// final isCorrectB = false.obs;
// final isCorrectC = false.obs;
// final isCorrectD = false.obs;

class _AnswerScreenState extends State<AnswerScreen> {
  // String? correctAnswer = "A";
  final questionController = Get.put(QuestionController());
  final answerController = Get.find<AnswerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Answers"),

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
                          text: 'Answers',
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
                    "Answers",
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
                                      const ViewAnswerScreen(),
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
                          "View Answers",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add Answer",
                            style: TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Obx(
                              () => DropdownButtonFormField<int>(
                                value:
                                    questionController.selectedQuestionId.value,
                                items: questionController.questions
                                    .map(
                                      (question) => DropdownMenuItem<int>(
                                        value: question.questionId,
                                        child: Text(question.question),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  questionController.selectedQuestionId.value =
                                      value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                hint: const Text('Choose question'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Obx(
                            () => SwitchListTile(
                              title: const Text(
                                "Allow Multiple Correct Answers",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              value: answerController.isMultipleChoice.value,
                              onChanged: (val) {
                                answerController.isMultipleChoice.value = val;
                                answerController.correctAnswers
                                    .clear(); // reset selection
                              },
                              activeColor: const Color(0xFF007F06),
                            ),
                          ),

                          /// ANSWER A
                          AnswerInput(
                            controllerr: answerAController,
                            label: "Answer A",
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER B
                          AnswerInput(
                            controllerr: answerBController,
                            label: "Answer B",
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER C
                          AnswerInput(
                            controllerr: answerCController,
                            label: "Answer C",
                          ),

                          const SizedBox(height: 15),

                          /// ANSWER D
                          AnswerInput(
                            controllerr: answerDController,
                            label: "Answer D",
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: () {
                                    final answerA = answerAController.text
                                        .trim();
                                    final answerB = answerBController.text
                                        .trim();
                                    final answerC = answerCController.text
                                        .trim();
                                    final answerD = answerDController.text
                                        .trim();

                                    final question = questionController
                                        .selectedQuestionId
                                        .value;
                                    final correctAnswerString = answerController
                                        .correctAnswers
                                        .join(',');

                                    // print("Selected Question ID: $question,$answerA,$answerB,$answerC,$answerD,${answerController.correctAnswer.value}  ");
                                    if (answerController
                                        .correctAnswers
                                        .isEmpty) {
                                      Get.snackbar(
                                        "Error",
                                        "Please select the correct answer",
                                      );
                                      return;
                                    }

                                    if (question == null ||
                                        answerA.isEmpty ||
                                        answerB.isEmpty ||
                                        answerC.isEmpty ||
                                        answerD.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'Please fill in all answers',
                                      );
                                      return;
                                    }
                                    // print(
                                    //   "Question ID: $question,$answerA,$answerB,$answerC,$answerD,${answerController.correctAnswer.value}  ",
                                    // );

                                    if (answerController.isEditing.value) {
                                      // UPDATE
                                      answerController.updateAnswer(
                                        answerController.editingAnswerId!,
                                        question,
                                        answerA,
                                        answerB,
                                        answerC,
                                        answerD,
                                        correctAnswerString,
                                      );
                                    } else {
                                      // print("Question ID: $question,$answerA,$answerB,$answerC,$answerD,${answerController.correctAnswer.value}  ");
                                      // SAVE
                                      answerController.addAnswer(
                                        question,
                                        answerA,
                                        answerB,
                                        answerC,
                                        answerD,
                                        correctAnswerString,
                                      );
                                    }

                                    // Reset
                                    answerController.resetForm();
                                    answerController.cancelEdit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        answerController.isEditing.value
                                        ? Colors.orange
                                        : const Color(0xFF007F06),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 100,
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Text(
                                    answerController.isEditing.value
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

class AnswerInput extends StatelessWidget {
  final String label;
  final TextEditingController controllerr;

  const AnswerInput({
    super.key,
    required this.label,
    required this.controllerr,
  });

  @override
  Widget build(BuildContext context) {
    final answerController = Get.find<AnswerController>();

    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: answerController.correctAnswers.contains(label),

            onChanged: (val) {
              if (answerController.isMultipleChoice.value) {
                // MULTI
                if (val == true) {
                  answerController.correctAnswers.add(label);
                } else {
                  answerController.correctAnswers.remove(label);
                }
              } else {
                // SINGLE (QCM)
                answerController.correctAnswers.clear();
                if (val == true) {
                  answerController.correctAnswers.add(label);
                }
              }
            },

            activeColor: const Color(0xFF007F06),
          ),
          Expanded(
            child: TextField(
              controller: controllerr,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
