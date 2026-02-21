import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/LoginScren.dart';
import 'package:mini_quiz/pages/user_side/quiz_QCM2.dart';
import 'package:mini_quiz/pages/user_side/quizmain.dart';
import 'package:mini_quiz/provider/fetchlevel_provider.dart';
import 'package:provider/provider.dart';

class LevelPage extends StatefulWidget {
  final int catagoryId;
  LevelPage({super.key, required this.catagoryId});
  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  Color _getColor(int index) {
    List<Color> colors = [
      Color(0xFFF35B6DA),
      Color(0xFFF7EDCD1),
      Color(0xFFF314A9D),
    ];
    return colors[index % colors.length];
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<LevelProviders>().fetchLevels(widget.catagoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Consumer<LevelProviders>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Quiz",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  "Choose your level!",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.levelList.length,
                    itemBuilder: (context, index) {
                      final level = provider.levelList[index];
                      return quizButton(
                        text: level.levelName,
                        color: _getColor(index),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizMainScreen(
                                categoryId: widget.catagoryId,
                                levelId: level.levelId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget quizButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: color,
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