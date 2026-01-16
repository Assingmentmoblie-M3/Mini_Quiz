import 'package:flutter/material.dart';
import 'package:mini_quiz/components/layout/admin_sidebar.dart';
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text("Dashboard", style: TextStyle(fontSize: 30))),
    Center(child: Text("Category", style: TextStyle(fontSize: 30))),
    Center(child: Text("Questions", style: TextStyle(fontSize: 30))),
    Center(child: Text("Answers", style: TextStyle(fontSize: 30))),
    Center(child: Text("Users", style: TextStyle(fontSize: 30))),
    Center(child: Text("Result", style: TextStyle(fontSize: 30))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Quiz Admin"),
      ),
      body: Row(
        children: [
          // Sidebar - always visible
          SizedBox(
            width: 250,
            child: AdminSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          ),

          // Content area - fills the rest
          Expanded(
            child: Container(
              color: Colors.grey[100], // optional background color
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}