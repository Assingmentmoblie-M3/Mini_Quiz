import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../layout/admin_sidebar.dart';
import '../../../components/section_card.dart';
import '../controller/result_controller.dart';

class ViewResultScreen extends StatelessWidget {
  ViewResultScreen({super.key});
  final ResultController controller = Get.put(ResultController());

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
                  const Text(
                    "Results",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 15),
                  // TABLE
                  Expanded(
                    child: SectionCard(
                      title: "Table Results",
                      onSearchChanged: (val) {
                        controller.search.value = val;
                        controller.fetchResults();
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

final resultController = Get.find<ResultController>();

class ResultTable extends StatelessWidget {
  ResultTable({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => DataTable(
            sortColumnIndex: 3,
            sortAscending: resultController.sortDirection.value == "asc",
            columns: [
              const DataColumn(
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
              const DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
      
                  child: Text(
                    "User Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              const DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Category Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                onSort: (columnIndex, ascending) async {
                  resultController.column.value = "total_score";
                  resultController.sortDirection.value =
                      resultController.sortDirection.value == "asc"
                      ? "desc"
                      : "asc";
      
                  await resultController.fetchResults();
                },
                label: Obx(
                  () => Row(
                    children: [
                      const Text(
                        "Total Score",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E5E5E),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        resultController.column.value == "total_score"
                            ? (resultController.sortDirection.value == "asc"
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward)
                            : Icons
                                  .unfold_more, // show neutral icon when not sorted
                        size: 16,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            rows: resultController.results.map((result) {
              final index = resultController.results.indexOf(result) + 1;
              return DataRow(
                cells: [
                  DataCell(Text(index.toString())),
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(result.user.userEmail),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(result.category.categoryName),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(result.totalScore.toString(), style: TextStyle(color: Color(0xFF009E08))),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
