import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/view_user_page.dart';
<<<<<<< HEAD
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
=======

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}
class _UserScreenState extends State<UserScreen> {
  @override
>>>>>>> main
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
<<<<<<< HEAD
                          style: TextStyle(color: Color(0xFF8C8C8C)),
=======
                          style: TextStyle(color: Color(0xFF8C8C8C), fontFamily: 'Fredoka'),
>>>>>>> main
                        ),
                        TextSpan(
                          text: 'Users',
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
<<<<<<< HEAD
=======
                            fontFamily: 'Fredoka'
>>>>>>> main
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
<<<<<<< HEAD
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewUserScreen(),
=======
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ViewUserScreen(),
                              transitionDuration: Duration.zero, // no animation
                              reverseTransitionDuration:
                                  Duration.zero, // no animation when back
>>>>>>> main
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
<<<<<<< HEAD
                            horizontal: 25,
=======
                            horizontal: 40,
>>>>>>> main
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
<<<<<<< HEAD
                              color: Colors.grey.shade600,
=======
                              color: const Color(0xFF5C5C5C),
>>>>>>> main
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "User Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
<<<<<<< HEAD
                          SizedBox(height: 10),
                          
                          const SizedBox(height: 10),
=======
                          

                          const SizedBox(height: 20),
>>>>>>> main
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007F06),
                                  padding: const EdgeInsets.symmetric(
<<<<<<< HEAD
                                    horizontal: 25,
=======
                                    horizontal: 100,
>>>>>>> main
                                    vertical: 20,
                                  ),
                                ),
                                child: const Text(
<<<<<<< HEAD
                                  "Add User",
=======
                                  "Save",
>>>>>>> main
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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
