import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'answer_page.dart';
import 'package:mini_quiz/components/action_button.dart';

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
          const Sidebar(selected: "Answers"),
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
                          text: 'Home > ',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Answers',
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
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
                    padding: EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const AnswerScreen(),
                              transitionDuration: Duration.zero, // no animation
                              reverseTransitionDuration:
                                  Duration.zero, // no animation when back
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
                          "Add New Answer",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Answers",
                      child: AnswerTable(),
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
}
