import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/result_controller.dart';
import 'package:mini_quiz/pages/admin_side/controller/user_controller.dart';
import 'package:mini_quiz/pages/admin_side/view/view_result_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_user_page.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? headerAction;
  final Color? borderColor;

  // New optional parameter for search
  final String? searchHint;
  final Function(String)? onSearchChanged;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.headerAction,
    this.borderColor,
    this.searchHint,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget? headerWidget = headerAction;

    // If searchHint is provided, override headerAction with styled search field
    if (searchHint != null && onSearchChanged != null) {
      headerWidget = SizedBox(
        width: 300,
        child: TextField(
          onChanged: onSearchChanged,
          style: const TextStyle(color: Color(0xFF008DB3)),
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: const TextStyle(color: Color(0xFF008DB3)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF008DB3)),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF008DB3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF008DB3)),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor ?? Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
              if (headerWidget != null) headerWidget,
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------- TABLES ----------------

class RecentQuizTable extends StatelessWidget {
   RecentQuizTable({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
            ),
      
            DataColumn(
              label: Text(
                "Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
            ),
          ],
          rows: userController.filteredUsers
              .where(
                (user) => user.userId == userController.filteredUsers.last.userId,
              )
              .map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.email.toString())),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(232, 248, 233, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Active",
                            style: TextStyle(color: Color(0xFF00D60B)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
              .toList(),
        ),
      ),
    );
  }
}

class FavTopicTable extends StatelessWidget {
  FavTopicTable({super.key});
  final ResultController resultController = Get.find<ResultController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox( child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                "Topic",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Unique Users",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E5E5E),
                ),
              ),
            ),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text(resultController.theMostCategory.value)),
                DataCell(
                  Text(resultController.theMostCategoryUsed.value.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
