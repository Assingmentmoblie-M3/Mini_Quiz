import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/admin_dashboard_page.dart';
import 'package:mini_quiz/pages/admin_side/view_category_page.dart';
import 'package:mini_quiz/pages/admin_side/view_level_page.dart';
import 'package:mini_quiz/pages/admin_side/view_user_page.dart';
import 'package:mini_quiz/pages/admin_side/view_question_page.dart';
import 'package:mini_quiz/pages/admin_side/view_result_page.dart';
import 'package:mini_quiz/pages/admin_side/view_answer_page.dart';

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
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashboardScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),
          _menuItem(
            icon: Icons.category,
            title: "Category",
            active: selected == "Category",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ViewCategoryScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),
          _menuItem(
            icon: Icons.bar_chart,
            title: "Levels",
            active: selected == "Levels",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                     ViewLevelScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),

          _menuItem(
            icon: Icons.help_outline,
            title: "Questions",
            active: selected == "Questions",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ViewQuestionScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),

          _menuItem(
            icon: Icons.check_circle_outline,
            title: "Answers",
            active: selected == "Answers",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ViewAnswerScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),
          _menuItem(
            icon: Icons.people_outline,
            title: "Users",
            active: selected == "Users",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ViewUserScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),
          _menuItem(
            icon: Icons.assignment_outlined,
            title: "Results",
            active: selected == "Results",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ViewResultScreen(),
                transitionDuration: Duration.zero, // no animation
                reverseTransitionDuration:
                    Duration.zero, // no animation when back
              ),
            ),
          ),
        ],
      ),
    );
  }
}
