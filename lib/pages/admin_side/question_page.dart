import 'package:flutter/material.dart';
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

    _questionController =
        TextEditingController(text: widget.questionText ?? "");
    _scoreController =
        TextEditingController(text: widget.score?.toString() ?? "");

    selectedCategoryId = widget.categoryId;
    selectedLevelId = widget.levelId;

    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchCategories();
      Provider.of<LevelProvider>(context, listen: false)
          .fetchLevel();
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

    final provider =
        Provider.of<QuestionProvider>(context, listen: false);

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
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
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
                  const Text(
                    "Questions",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
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
                                    hint:
                                        const Text("Choose Category"),
                                    items: provider.categories
                                        .map<DropdownMenuItem<int>>((cat) {
                                      return DropdownMenuItem<int>(
                                        value: cat['category_id'],
                                        child: Text(
                                            cat['category_name'] ?? ""),
                                      );
                                    }).toList(),
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
                                    items: provider.level
                                        .map<DropdownMenuItem<int>>((level) {
                                      return DropdownMenuItem<int>(
                                        value: level['level_id'],
                                        child: Text(
                                            level['level_name'] ?? ""),
                                      );
                                    }).toList(),
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
                                  onPressed:
                                      _isSubmitting ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF007F06),
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

/*import 'package:flutter/material.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/view_question_page.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});
  @override
  State<QuestionScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<QuestionScreen> {
  
  String? selectedCategory;
  String? selectLevels;
  final List<String> categories = [
    'Math',
    'Science',
    'English',
    'General Knowledge',
  ];
  //for select levels
  final List<String> levels = ['Level 1', 'Level 2'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Questions"),

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
                          text: "Questions",
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Questions
                  const SizedBox(height: 10),
                  const Text(
                    "Questions",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //View Questions
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewQuestionScreen(),
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
                            "Add Questions",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Filed
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Questions",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          //Score
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Score",
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
                            height: 40,
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              value: selectedCategory,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: const Text('Select category'),
                              items: categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select category'
                                  : null,
                            ),
                          ),
                          //
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              value: selectLevels,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: const Text('Select Levels'),
                              items: levels
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectLevels = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Please select Levels' : null,
                            ),
                          ),
                          //
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007F06),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 20,
                                  ),
                                ),
                                child: const Text(
                                  "Add Question",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
}*/
