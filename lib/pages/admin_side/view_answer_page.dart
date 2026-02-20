import 'package:flutter/material.dart';
import 'package:mini_quiz/provider/answer_provider.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'answer_page.dart'; // ត្រូវប្រាកដថា file name ត្រូវ (AnswerScreen)

class ViewAnswerScreen extends StatefulWidget {
  const ViewAnswerScreen({super.key});

  @override
  State<ViewAnswerScreen> createState() => _ViewAnswerScreenState();
}

class _ViewAnswerScreenState extends State<ViewAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          // Sidebar Menu
          const Sidebar(selected: "Answers"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
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
                    "Answers Management",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),
                  // Button Add New
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const AnswerScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add New Answer",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007F06),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Table Section
                  Expanded(
                    child: SectionCard(
                      title: "List of All Answers",
                      child: const AnswerTable(),
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

class AnswerTable extends StatefulWidget {
  const AnswerTable({super.key});

  @override
  State<AnswerTable> createState() => _AnswerTableState();
}

class _AnswerTableState extends State<AnswerTable> {
  @override
  void initState() {
    super.initState();
    // Fetch data ពេល load page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnswerProvider>(context, listen: false).fetchAnswers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnswerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF007F06)),
          );
        }

        if (provider.answers.isEmpty) {
          return const Center(child: Text("No data found."));
        }

        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
              columns: const [
                DataColumn(label: _Header("No")),
                DataColumn(label: _Header("Actions")),
                DataColumn(label: _Header("Questions")),
                DataColumn(label: _Header("Answer A")),
                DataColumn(label: _Header("Answer B")),
                DataColumn(label: _Header("Answer C")),
                DataColumn(label: _Header("Answer D")),
                DataColumn(label: _Header("Correct Answers")),
              ],
              // ក្នុងផ្នែក DataTable ត្រង់ rows:
              rows: provider.answers.asMap().entries.map((entry) {
                int index = entry.key;
                Map item = entry.value;

                return DataRow(
                  cells: [
                    // 1. លេខរៀង (No)
                    DataCell(Text("${index + 1}")),

                    // 2. សកម្មភាព (Actions)
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () => _navigateToEdit(item),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () => _confirmDelete(item['answer_id']),
                          ),
                        ],
                      ),
                    ),

                    // 3. ឈ្មោះសំណួរ (Question Name) - ទាញពី Key ដែលយើងបានថែមក្នុង Resource
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          // បើ question_text null វានឹងបង្ហាញពាក្យ "No Question" ជំនួស
                          item['question']?.toString() ?? "No Question",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // 4. ចម្លើយ A, B, C, D
                    DataCell(Text(item['answer_a'] ?? "")),
                    DataCell(Text(item['answer_b'] ?? "")),
                    DataCell(Text(item['answer_c'] ?? "")),
                    DataCell(Text(item['answer_d'] ?? "")),

                    // 5. ចម្លើយដែលត្រឹមត្រូវ (Correct Answer)
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item['is_correct'] ?? "",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Logic Helpers
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete Answer ID: $id?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await Provider.of<AnswerProvider>(
                context,
                listen: false,
              ).deleteAnswer(id);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(Map item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnswerScreen(editData: item),
      ),
    );
  }

}

// Header Styling
class _Header extends StatelessWidget {
  final String title;
  const _Header(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/*
class AnswerTable extends StatelessWidget {
  const AnswerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(
            numeric: true,
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "No.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Actions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Question",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Answer A",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Answer B",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Answer C",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Answer C",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Text(
                  "Created At",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("1")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ActionButtons(
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AnswerScreen()),
                      );
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Are you sure deleting answer?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("Q1")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("Answer A")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("Answer B")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("Answer C")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("Answer D")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(child: Text("2026-01-01")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
