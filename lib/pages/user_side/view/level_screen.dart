import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/level_controller.dart';
import 'package:mini_quiz/pages/admin_side/controller/result_controller.dart';
import 'package:mini_quiz/pages/user_side/view/dynamic_quiz_screen.dart';
import '../../admin_side/model/level_model.dart';

import '../view/result_screen.dart';

const List<Color> levelColors = [
  Color(0xFF7EDCD1),
  Color(0xFF35B6DA),
  Color(0xFF314A9D),
  Color(0xFFA8BEFF),
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.blueGrey,
];
class LevelPage extends StatefulWidget {
  final int categoryId;

  const LevelPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late final LevelController levelController;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    try {
      if (Get.isRegistered<LevelController>()) {
        levelController = Get.find<LevelController>();
      } else {
        levelController = Get.put(LevelController());
      }
      _loadLevels();
    } catch (e) {
      print('Error initializing controller: $e');
    }
  }

  Future<void> _loadLevels() async {
    try {
      await levelController.fetchLevels();
      if (mounted) {
        levelController.filteredLevels.assignAll(
          levelController.levels
              .where((level) => level.category.categoryId == widget.categoryId)
              .toList(),
        );
      }
    } catch (e) {
      print('Error loading levels: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.chevron_back),
          color: Colors.green,
          iconSize: 30,
        ),
      ),
      // backgroundColor: const Color(0xFFE0E0E0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quiz",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00D60B),
              ),
            ),
            Text(
              "Choose your topic!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF5C5C5C),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Obx(() {
                if (levelController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (levelController.filteredLevels.isEmpty) {
                  return const Center(child: Text("No levels found"));
                }
                return ListView(
                  children: levelController.filteredLevels.map((Level level) {
                    return quizButton(
                      text: level.levelName,
                      colorLevel: levelColors[level.levelId % levelColors.length],
                      onTap: () async {
                        try {
                          final levelAnswers = await levelController.answerController
                              .fetchAnswersByLevel(level.levelId);
                          
                          if (!mounted) return;
                          
                          if (levelAnswers.isEmpty) {
                            Get.snackbar('Info', 'No questions available for this level');
                            return;
                          }
                          
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DynamicQuizPage(
                                answers: levelAnswers,
                                levelId: level.levelId,
                              ),
                            ),
                          );
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget quizButton({
    required String text,
    required VoidCallback onTap,
    required Color colorLevel
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: colorLevel,
            borderRadius: BorderRadius.circular(35),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 6),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}