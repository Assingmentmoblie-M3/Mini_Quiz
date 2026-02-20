import 'package:mini_quiz/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/pages/admin_side/user_page.dart';
import 'package:mini_quiz/components/action_button.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  String searchText = "";
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false).fetchUsers(),
    );
  }

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
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Users',
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
                    "Users",
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
                                      UserScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
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
                          "Add New User",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Users",
                      onSearchChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      searchHint: "Search users...",
                      child: UserTable(),
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

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.users.isEmpty) {
          return const Center(child: Text("No users found"));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                numeric: true,
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                  padding: EdgeInsets.symmetric(horizontal: 50),
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
            rows: List.generate(provider.users.length, (index) {
              final user = provider.users[index];
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                  DataCell(
                    ActionButtons(
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserScreen(
                              id: user['user_id'], // 🔥 Pass this!
                              email: user['email'],
                              roleId: user['role_id'],
                              status: user['status'],
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        bool? confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Are you sure to delete user?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).deleteUser(user['user_id']);
                        }
                      },
                    ),
                  ),
                  DataCell(Text(user['email'] ?? "")),
                  DataCell(Text(user['status'] == 1 ? "Active" : "Inactive")),
                  DataCell(Text(user['created_at'] ?? "")),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
