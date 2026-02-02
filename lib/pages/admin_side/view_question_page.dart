import 'package:flutter/material.dart';
import 'package:mini_quiz/components/action_button.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/question_page.dart';

class ViewQuestionScreen extends StatefulWidget {
  const ViewQuestionScreen({super.key});
  @override
  State<ViewQuestionScreen> createState() => _ViewQuestionScreenState();
}

class _ViewQuestionScreenState extends State<ViewQuestionScreen> {
  String searchText = "";
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
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(color: Color(0xFF8C8C8C)),
                        ),
                        TextSpan(
                          text: 'Questions',
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuestionScreen(),
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
                          "Add New Question",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Questions",
                      onSearchChanged: (value) {
                        setState(() {
                           searchText = value;
                        });
                      },
                      searchHint: "Search questions...",
                      child: const QuestionsTable(),
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
class QuestionsTable extends StatefulWidget {
  const QuestionsTable({super.key});

  @override
  State<QuestionsTable> createState() => _QuestionsTableState();
}

class _QuestionsTableState extends State<QuestionsTable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(
            numeric: true,
            label: Center(
              child: Text(
                "No.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
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
              padding: EdgeInsets.symmetric(horizontal: 25),
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
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Center(
                child: Text(
                  "Score",
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
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Center(
                child: Text(
                  "Category",
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
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Text(
                  "Level",
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
              DataCell(Center(child: Text("1"))),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ActionButtons(
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuestionScreen(),
                        ),
                      );
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Are you sure deleting category?"),
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
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(child: Text("What is the capital of France?")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(child: Text("1")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(child: Text("English")),
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(child: Text("Easy")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
