import 'package:flutter/material.dart';
import 'package:mini_quiz/components/action_button.dart';
import 'package:mini_quiz/pages/admin_side/view_question_page.dart';
import 'package:mini_quiz/pages/admin_side/view_user_page.dart';
import 'package:mini_quiz/provider/qusetion_provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/provider/category_provider.dart';
import 'package:mini_quiz/provider/level_provider.dart';

class QuestionScreen extends StatefulWidget {
  final int? questionId;
  final String? questionText;
  final int? score;
  final int? categoryId;
  final int? levelId;

  const QuestionScreen({
    this.questionId,
    this.questionText,
    this.score,
    this.categoryId,
    this.levelId,
    super.key,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _scoreController;

  int? selectedCategoryId;
  int? selectedLevelId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController(
      text: widget.questionText ?? "",
    );
    _scoreController = TextEditingController(
      text: widget.score?.toString() ?? "",
    );

    selectedCategoryId = widget.categoryId;
    selectedLevelId = widget.levelId;

    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<LevelProvider>(context, listen: false).fetchLevel();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryId == null || selectedLevelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select category and level")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = Provider.of<QuestionProvider>(context, listen: false);

    bool success;

    if (widget.questionId == null) {
      // ADD
      success = await provider.addQuestion(
        question: _questionController.text.trim(),
        score: int.parse(_scoreController.text.trim()),
        categoryId: selectedCategoryId!,
        levelId: selectedLevelId!,
      );
    } else {
      // UPDATE
      success = await provider.updateQuestion(
        id: widget.questionId!,
        question: _questionController.text.trim(),
        score: int.parse(_scoreController.text.trim()),
        categoryId: selectedCategoryId!,
        levelId: selectedLevelId!,
      );
    }

    setState(() => _isSubmitting = false);

    if (success) {
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

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
                          text: 'Home > ',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Users',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Questions",
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
                                      ViewQuestionScreen(),
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
                          "View Questions",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.questionId == null
                                    ? "Add Question"
                                    : "Edit Question",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Question Field
                              TextFormField(
                                controller: _questionController,
                                decoration: const InputDecoration(
                                  labelText: "Question",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter question";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Score Field
                              TextFormField(
                                controller: _scoreController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Score",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter score";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Score must be number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              // Category Dropdown
                              Consumer<CategoryProvider>(
                                builder: (context, provider, child) {
                                  return DropdownButtonFormField<int>(
                                    value: selectedCategoryId,
                                    hint: const Text("Choose Category"),
                                    items: provider.categories
                                        .map<DropdownMenuItem<int>>((cat) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                cat['category_id'], // from API
                                            child: Text(
                                              cat['category_name'] ?? "",
                                            ),
                                          );
                                        })
                                        .toList(),

                                    /* items: provider.categories
                                        .map<DropdownMenuItem<int>>((cat) {
                                      return DropdownMenuItem<int>(
                                        value: cat['category_id'],
                                        child: Text(
                                            cat['category_name'] ?? ""),
                                      );
                                    }).toList(), */
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategoryId = value;
                                      });
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 15),

                              // Level Dropdown
                              Consumer<LevelProvider>(
                                builder: (context, provider, child) {
                                  return DropdownButtonFormField<int>(
                                    value: selectedLevelId,
                                    hint: const Text("Choose Level"),
                                    /* items: provider.level
                                        .map<DropdownMenuItem<int>>((level) {
                                      return DropdownMenuItem<int>(
                                        value: level['level_id'],
                                        child: Text(
                                            level['level_name'] ?? ""),
                                      );
                                    }).toList(),*/
                                    items: provider.level
                                        .map<DropdownMenuItem<int>>((level) {
                                          return DropdownMenuItem<int>(
                                            value:
                                                level['level_id'], // ⚠️ note key
                                            child: Text(
                                              level['level_name'] ?? "",
                                            ),
                                          );
                                        })
                                        .toList(),

                                    onChanged: (value) {
                                      setState(() {
                                        selectedLevelId = value;
                                      });
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 25),

                              SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007F06),
                                  ),
                                  child: _isSubmitting
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          widget.questionId == null
                                              ? "Add Question"
                                              : "Update Question",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
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
    );
  }
}
