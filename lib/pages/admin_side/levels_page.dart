import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/provider/category_provider.dart';
import 'package:mini_quiz/provider/level_provider.dart';

class LevelsScreen extends StatefulWidget {
  final int? levelId;
  final String? levelName;
  final String? description;
  final int? categoryId;

  const LevelsScreen({
    this.levelId,
    this.levelName,
    this.description,
    this.categoryId,
    super.key,
  });

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _levelNameController;
  late TextEditingController _descriptionController;
  int? selectedCategoryId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _levelNameController =
        TextEditingController(text: widget.levelName ?? "");
    _descriptionController =
        TextEditingController(text: widget.description ?? "");
    selectedCategoryId = widget.categoryId;

    // Fetch categories
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false)
            .fetchCategories());
  }

  @override
  void dispose() {
    _levelNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")));
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = Provider.of<LevelProvider>(context, listen: false);
    bool success;

    if (widget.levelId == null) {
      // Add new level
      success = await provider.createLevel(
        _levelNameController.text.trim(),
        _descriptionController.text.trim(),
        selectedCategoryId,
      );
    } else {
      // Update existing level
      success = await provider.updateLevel(
        widget.levelId!,
        _levelNameController.text.trim(),
        _descriptionController.text.trim(),
        selectedCategoryId,
      );
    }

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")));
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Levels",
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
                                widget.levelId == null
                                    ? "Add Level"
                                    : "Edit Level",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _levelNameController,
                                decoration: const InputDecoration(
                                  labelText: "Level Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter level name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter description";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              Consumer<CategoryProvider>(
                                builder: (context, provider, child) {
                                  if (provider.isLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return DropdownButtonFormField<int>(
                                    value: selectedCategoryId,
                                    hint: const Text("Choose Category"),
                                    items: provider.categories
                                        .map<DropdownMenuItem<int>>((cat) {
                                      return DropdownMenuItem<int>(
                                        value: cat['category_id'],
                                        child: Text(cat['category_name'] ?? ""),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategoryId = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select a category";
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: 180,
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
                                          widget.levelId == null
                                              ? "Add Level"
                                              : "Update Level",
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
