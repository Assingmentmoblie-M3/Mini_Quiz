import 'package:flutter/material.dart';
import 'package:mini_quiz/provider/answer_provider.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'answer_page.dart';
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Table Section
                  Expanded(
                    child: SectionCard(
                      title: "Table Answers",
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
        return Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label:  _Header("No"),),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Actions"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Questions"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Answer A"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Answer B"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Answer C"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Answer D"),
                  )),
                  DataColumn(label: Padding(
                    padding: EdgeInsets.symmetric(horizontal:15),
                    child: _Header("Correct Answers"),
                  )),
                ],
                rows: provider.answers.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map item = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text("${index + 1}")),
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
          
                    
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            item['question']?.toString() ?? "No Question",
                            style: const TextStyle(color:Color(0xFF5E5E5E),fontWeight: FontWeight.bold,fontFamily: 'Fredoka'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: Text(item['answer_a'] ?? "",style: TextStyle(color:Color(0xFF5E5E5E),fontFamily: 'Fredoka'),),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: Text(item['answer_b'] ?? "",style: TextStyle(color:Color(0xFF5E5E5E),fontFamily: 'Fredoka'),),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: Text(item['answer_c'] ?? "",style: TextStyle(color:Color(0xFF5E5E5E),fontFamily: 'Fredoka'),),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15),
                        child: Text(item['answer_d'] ?? "",style: TextStyle(color:Color(0xFF5E5E5E),fontFamily: 'Fredoka'),),
                      )),
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
                              fontFamily: 'Fredoka'
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
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
class _Header extends StatelessWidget {
  final String title;
  const _Header(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color:Color(0xFF5E5E5E),
        fontFamily: "Fredoka"
      ),
    );
  }
}
