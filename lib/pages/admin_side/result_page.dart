import 'package:mini_quiz/pages/admin_side/view_question_page.dart';
import 'package:mini_quiz/provider/user_provider.dart';

import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/provider/result_provider.dart';
import 'package:mini_quiz/pages/admin_side/view_result_page.dart';

class ResultScreen extends StatefulWidget {
  final int? id;
  final String? userEmail;
  final int? totalScore;
  final String? status;

  const ResultScreen({
    this.id,
    this.userEmail,
    this.totalScore,
    this.status,
    super.key,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _totalScoreController = TextEditingController();
  int? selectedUserId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // fetch user list from provider
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false).fetchUsers(),
    );

    if (widget.totalScore != null) {
      _totalScoreController.text = widget.totalScore.toString();
    }
    // If editing, you can map email to userId later
  }

  @override
  void dispose() {
    _totalScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Results"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... header & buttons ...
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
                          text: 'Result',
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
                  const SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add User",
                            style: TextStyle(
                              color: Color(0xFF5C5C5C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              return DropdownButtonFormField<int>(
                                value: selectedUserId,
                                decoration: InputDecoration(
                                  labelText: "Select User Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                                items: userProvider.users
                                    .map<DropdownMenuItem<int>>((user) {
                                      return DropdownMenuItem<int>(
                                        value:
                                            user['user_id'], // make sure it's int
                                        child: Text(user['email'] ?? ""),
                                      );
                                    })
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedUserId = value;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _totalScoreController,
                            decoration: InputDecoration(
                              labelText: "Total Score",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    if (selectedUserId == null ||
                                        _totalScoreController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please fill all fields",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() => _isSubmitting = true);
                                    final provider =
                                        Provider.of<ResultProvider>(
                                          context,
                                          listen: false,
                                        );
                                    int totalScore =
                                        int.tryParse(
                                          _totalScoreController.text,
                                        ) ??
                                        0;
                                    bool success = await provider.addResult(
                                      userId: selectedUserId!,
                                      categoryId: 1, // update properly
                                      totalScore: totalScore,
                                    );
                                    setState(() => _isSubmitting = false);
                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Result saved successfully",
                                          ),
                                        ),
                                      );
                                      _totalScoreController.clear();
                                      setState(() => selectedUserId = null);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Failed to save result",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: _isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Add Result",
                                    style: TextStyle(
                                      color: Color(0xFF5C5C5C),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
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
