import 'package:flutter/material.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/view_level_page.dart';
import 'package:mini_quiz/provider/category_provider.dart';
import 'package:mini_quiz/provider/level_provider.dart';
import 'package:provider/provider.dart';

class LevelsScreen extends StatefulWidget {
  final int? levelId;
  final String? name;
  final String? description;
  const LevelsScreen({this.levelId, this.name, this.description, super.key});
  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final _FormKey = GlobalKey<FormState>();
  late TextEditingController _levelName;
  late TextEditingController _levelDescr;
  bool _isSubmitting = false;
  int? selectedCategoryId;
  final List<String> categories = [
    'Math',
    'Science',
    'English',
    'General Knowledge',
  ];
  @override
  void initState() {
    super.initState();
    _levelName = TextEditingController(text: widget.name ?? "");
    _levelDescr = TextEditingController(text: widget.description ?? "");
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _levelName.dispose();
    _levelDescr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_FormKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final provider = Provider.of<LevelProvider>(context, listen: false);

    bool success;

    if (widget.levelId == null) {
      success = await provider.createLevel(
        _levelName.text,
        _levelDescr.text,
        selectedCategoryId
      );
    } else {
      success = await provider.updateLevel(
        widget.levelId!,
        _levelName.text,
        _levelDescr.text,
      );
    }

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
    } else {
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
                            MaterialPageRoute(
                              builder: (context) => ViewLevelScreen(),
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
                          //add Form
                          Form(
                            key: _FormKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: TextField(
                                    controller: _levelName,
                                    decoration: InputDecoration(
                                      labelText: "Levels Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Consumer<CategoryProvider>(
                                  builder: (context, provider, child) {
                                    if (provider.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return DropdownButtonFormField<int>(
                                      value: selectedCategoryId,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      hint: const Text('Choose category'),
                                      items: provider.categories
                                          .map<DropdownMenuItem<int>>((
                                            category,
                                          ) {
                                            return DropdownMenuItem<int>(
                                              value:
                                                  category['category_id'], // 👈 important
                                              child: Text(category['name']),
                                            );
                                          })
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategoryId = value;
                                        });
                                      },
                                      validator: (value) => value == null
                                          ? 'Please select category'
                                          : null,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                                  "Add Levels",
                                  style: TextStyle(
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
