import 'package:flutter/material.dart';
import 'package:mini_quiz/components/action_button.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/pages/admin_side/question_page.dart';
import 'package:mini_quiz/provider/qusetion_provider.dart';
import 'package:provider/provider.dart';

class ViewQuestionScreen extends StatefulWidget {
  const ViewQuestionScreen({super.key});
  @override
  State<ViewQuestionScreen> createState() => _ViewQuestionScreenState();
}

class _ViewQuestionScreenState extends State<ViewQuestionScreen> {
  String searchText = "";
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<QuestionProvider>(
        context,
        listen: false,
      ).fetchQuestions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          SizedBox(width: 250, child: const Sidebar(selected: "Questions")),

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
                              builder: (context) => QuestionScreen(),
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: SectionCard(
                      title: "Table Questions",
                      searchHint: "Search questions...",
                      onSearchChanged: (value) {},
                      child: SizedBox(
                        width: double.infinity,
                        child: QuestionsTable(),
                      ),
                    ),
                  ),

                  // },
                  // ),
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
    return Consumer<QuestionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.questions.isEmpty) {
          return const Center(child: Text("No Question Fount"));
        }
        return SizedBox(
            width:double.infinity,
            child:Scrollbar(
              child:SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30,
                columns: const [
                  DataColumn(
                    label: Text(
                      "No.",
                      style: TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Actions",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Question",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Score",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Category",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Level",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        "Created_at",
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: List.generate(provider.questions.length, (index) {
                  final q = provider.questions[index];
            
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: Color(0xFF5E5E5E),
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: ActionButtons(
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuestionScreen(
                                    questionId: q['question_id'],
                                    questionText: q['question'],
                                    score: q['score'],
                                    categoryId: q['category']?['id'],
                                    levelId: q['level']?['id'],
                                  ),
                                ),
                              );
                            },
                            onDelete: () async {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text(
                                    "Are you sure you want to delete?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
            
                              if (confirm == true) {
                                await provider.deleteQuestion(q['question_id']);
                              }
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            q['question'] ?? "",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            q['score']?.toString() ?? "",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            q['category']?['category_name'] ?? "",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            q['level']?['level_name'] ?? "",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            q['created_at'] ?? "",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontFamily: 'Fredoka',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            ),
          );
        
      },
    );
  }
}
