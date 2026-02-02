import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(16),
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
                style: const TextStyle(
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
  const RecentQuizTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
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
              "Level",
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
        rows: [
          DataRow(
            cells: [
              DataCell(Text("Math")),
              DataCell(Text("Easy")),
              DataCell(
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 248, 233, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(
                        color: Color(0xFF00D60B),
                        backgroundColor: Color.fromRGBO(232, 248, 233, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavTopicTable extends StatelessWidget {
  const FavTopicTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
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
              "Total Users",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),
        ],
        rows: const [
          DataRow(
            cells: [DataCell(Text("General Knowledge")), DataCell(Text("10"))],
          ),
        ],
      ),
    );
  }
}
