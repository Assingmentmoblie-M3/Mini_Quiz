import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/pages/admin_side/user_page.dart';
import 'package:mini_quiz/components/action_button.dart';
class ViewUserScreen extends StatelessWidget {
  const ViewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Users"),

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
                          text: 'Users',
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
                    "Users",
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
                              builder: (context) =>
                                  const UserScreen(),
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
                          "Add New User",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: Row(
                      children: const [
                        Expanded(
                          child: SectionCard(
                            title: "Table Users",
                            child: UserTable(),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
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

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(
            numeric: true,
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
              padding: const EdgeInsets.symmetric(horizontal: 50),
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
              padding: const EdgeInsets.symmetric(horizontal: 35),
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(child: Text("1")),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ActionButtons(
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UserScreen()),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(child: Text("hengmean@gmail.com")),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 248, 233, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Active",
                      style: TextStyle(
                        color: Color(0xFF00D60B),
                        backgroundColor: Color.fromRGBO(232, 248, 233, 1),
                      ),
                    ),
                  ),
                ),
                
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
