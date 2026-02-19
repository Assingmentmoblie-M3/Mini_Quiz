import 'package:mini_quiz/provider/result_provider.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'result_page.dart';
class ViewResultScreen extends StatefulWidget {
  const ViewResultScreen({super.key});
  @override
  State<ViewResultScreen> createState() => _ViewResultScreenState();
}

class _ViewResultScreenState extends State<ViewResultScreen> {
  String searchText = "";
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ResultProvider>(context, listen: false).fetchResults(),
    );
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
                          text: 'Results',
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
                    "Results",
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
                                      ResultScreen(),
                              transitionDuration: Duration.zero, // no animation
                              reverseTransitionDuration:
                                  Duration.zero, // no animation when back
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Add New Result",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Results",
                      onSearchChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      searchHint: "Search...",
                      child: ResultTable(),
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

class ResultTable extends StatelessWidget {
  const ResultTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.results.isEmpty) {
          return const Center(child: Text("No result found"));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
                      "User Email",
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
                      "Total Score",
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
                      "Status",
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
                                  rows: List.generate(provider.results.length, (index) {
                        final result = provider.results[index];
                        return DataRow(
                          cells: [
                            DataCell(Text("${index + 1}")),
                            DataCell(Text(result.userEmail)),
                            DataCell(Text(result.categoryName)),
                            DataCell(Text(result.totalScore.toString())),
                            DataCell(Text(result.status)),
                            DataCell(Text(result.createdAt)),
                          ],
                        );
                      }),
           /* rows: List.generate(provider.results.length, (index) {
              final result = provider.results[index];
              return DataRow(
                cells: [
                  DataCell(Text("${index + 1}")),
                  DataCell(
                    ActionButtons(
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ResultScreen()),
                        );
                      },
                      onDelete: () {},
                    ),
                  ),
                  DataCell(Text(result.userEmail)),
                  DataCell(Text(result.totalScore.toString())),
                  DataCell(Text(result.status)),
                  DataCell(Text(result.createdAt)),
                ],
              );
            }),*/
          ),
        );
      },
    );
  }
}
