import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/components/stat_card.dart';
import 'package:mini_quiz/pages/admin_side/view/view_user_page.dart';
import '../controller/result_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  final ResultController resultController = Get.put(ResultController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Dashboard"),
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
                          style: TextStyle(color: Color(0xFF8C8C8C), fontFamily: 'Fredoka',),
                        ),
                        TextSpan(
                          text: 'Dashboard',
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
                    "Dashboard",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Top statistics
                  Row(
                    children: [
                      Obx(() => StatCard(
                        title: "Total Users",
                        value: userController.users.length.toString(),
                        color: Colors.green,
                      ),
                      ),
                      SizedBox(width: 16),
                      Obx(() => resultController.totalQuizzes.value > 0
                          ? StatCard(
                              title: "Total Quizzes",
                              value: resultController.totalQuizzes.value.toString(),
                              color: Colors.orange,
                            )
                          : const SizedBox()),

                      SizedBox(width: 16),
                      StatCard(
                        title: "Average Score",
                        value: "80%",
                        color: Colors.pink,
                      ),
                      SizedBox(width: 16),
                      StatCard(
                        title: "Completion Rate",
                        value: "85%",
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: SectionCard(
                            title: "Recent Quiz Attempts",
                            child: RecentQuizTable(),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: SectionCard(
                            title: "Fav Topic",
                            child: FavTopicTable(),
                          ),
                        ),
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