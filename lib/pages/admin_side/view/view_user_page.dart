import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/user_controller.dart';

import '../../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/pages/admin_side/view/user_page.dart';
import 'package:mini_quiz/components/action_button.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  String searchText = "";
  late final UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    userController.fetchUsers(); // ✅ fetch only here
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
                          emailController.clear();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const UserScreen(),
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
                        userController.searchUsers(value);
                      },
                      searchHint: "Search users...",
                      child: const UserTable(),
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

final userController = Get.put(UserController());

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => DataTable(
            columns: const [
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "No.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
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
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Role ID",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    "Created At",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
            ],
            rows: userController.filteredUsers.map((user) {
                                final index = userController.filteredUsers.indexOf(user) + 1;

              return DataRow(
                cells: [
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(index.toString()),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: ActionButtons(
                        onEdit: () {
                          userController.startEdit(user.userId, user.email);
                          emailController.text = user.email;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserScreen()),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Are you sure deleting user?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    userController.deleteUser(user.userId);
                                    Navigator.pop(context);
                                  },
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
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(user.email),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(user.roleId.toString()),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: user.status ? const Color(0xFFE8F8E9) : Color(0xFFADE2F0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          user.status ? "Active" : "Completed",
                          style: TextStyle(
                            color: user.status ? Color(0xFF00D60B) : Color(0xFF008DB3),
                            backgroundColor: user.status ? Color(0xFFE8F8E9) : Color(0xFFADE2F0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(user.createdAt.toIso8601String().split('T')[0]),
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
