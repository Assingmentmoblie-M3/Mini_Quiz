import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view_user_page.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/user_controller.dart';
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}
final emailController = TextEditingController();
class _UserScreenState extends State<UserScreen> {
  
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
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
                                      const ViewUserScreen(),
                              transitionDuration: Duration.zero, // no animation
                              reverseTransitionDuration:
                                  Duration.zero, // no animation when back
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "View Users",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add User",
                            style: TextStyle(
                              color: const Color(0xFF5C5C5C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "User Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: () {
                                    final email = emailController.text
                                        .trim();
                                    if (email.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'Please fill in this fields',
                                      );
                                      return;
                                    }

                                    if (userController.isEditing.value) {
                                      // UPDATE
                                      userController.updateUser(
                                        userController.editingUserId!,
                                        email,
                                      );
                                    } else {
                                      // SAVE
                                      userController.addUser(email);
                                    }

                                    // Reset
                                    emailController.clear();
                                    userController.cancelEdit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        userController.isEditing.value
                                        ? Colors.orange
                                        : const Color(0xFF007F06),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 100,
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Text(
                                    userController.isEditing.value
                                        ? "Update"
                                        : "Save",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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
