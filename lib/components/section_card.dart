import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E5E5E),
            ),
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
        rows: const [
          DataRow(
            cells: [
              DataCell(Text("Math")),
              DataCell(Text("Easy")),
              DataCell(
                Text("Active", style: TextStyle(color: Color(0xFF00D60B))),
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
