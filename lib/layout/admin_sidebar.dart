import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/user_controller.dart';
import 'package:mini_quiz/pages/admin_side/view/admin_dashboard_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_category_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_level_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_user_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_question_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_result_page.dart';
import 'package:mini_quiz/pages/admin_side/view/view_answer_page.dart';
import 'package:mini_quiz/pages/user_side/view/login_screen.dart';

// final UserController userController = Get.find<UserController>();
class Sidebar extends StatelessWidget {
  final String selected;

  const Sidebar({super.key, required this.selected});

  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: active ? Colors.black26 : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? const Color(0xFF62FF6A) : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: active ? const Color(0xFF62FF6A) : Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: const Color(0xFF5E5E5E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'mini ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  TextSpan(
                    text: 'Quiz\n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color(0xFF00D60B), // override the color
                    ),
                  ),
                  TextSpan(
                    text: 'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fredoka',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          _menuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            active: selected == "Dashboard",
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          _menuItem(
            icon: Icons.category,
            title: "Category",
            active: selected == "Category",
            onTap: () => Navigator.pushNamed(context, '/categories_page'),
          ),
          _menuItem(
            icon: Icons.bar_chart,
            title: "Levels",
            active: selected == "Levels",
            onTap: () => Navigator.pushNamed(context, '/levels_page'),
          ),

          _menuItem(
            icon: Icons.help_outline,
            title: "Questions",
            active: selected == "Questions",
            onTap: () => Navigator.pushNamed(context, '/questions_page'),
          ),

          _menuItem(
            icon: Icons.check_circle_outline,
            title: "Answers",
            active: selected == "Answers",
            onTap: () => Navigator.pushNamed(context, '/answers_page'),
          ),
          _menuItem(
            icon: Icons.people_outline,
            title: "Users",
            active: selected == "Users",
            onTap: () => Navigator.pushNamed(context, '/users_page'),
          ),
          _menuItem(
            icon: Icons.assignment_outlined,
            title: "Results",
            active: selected == "Results",
            onTap: () => Navigator.pushNamed(context, '/result_page'),
          ),
          Column(
            children: [
              _menuItem(
                icon: Icons.logout,
                title: "Logout",
                active: selected == "Logout",
                onTap: () {
                  userController.logout();
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                  //
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
