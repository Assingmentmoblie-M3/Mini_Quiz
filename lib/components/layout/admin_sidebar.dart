import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String selected;

  const Sidebar({super.key, required this.selected});

  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Container(
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextSpan(
                    text: 'Quiz\n',
                    style: TextStyle(
                      color: const Color(0xFF00D60B),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
          ),
          _menuItem(
            icon: Icons.category,
            title: "Category",
            active: selected == "Category",
          ),
          _menuItem(
            icon: Icons.bar_chart,
            title: "Levels",
            active: selected == "Levels",
          ),
          _menuItem(
            icon: Icons.help_outline,
            title: "Questions",
            active: selected == "Questions",
          ),
          _menuItem(
            icon: Icons.check_circle_outline,
            title: "Answers",
            active: selected == "Answers",
          ),
          _menuItem(
            icon: Icons.people_outline,
            title: "Users",
            active: selected == "Users",
          ),
          _menuItem(
            icon: Icons.assignment_outlined,
            title: "Results",
            active: selected == "Results",
          ),
        ],
      ),
    );
  }
}
