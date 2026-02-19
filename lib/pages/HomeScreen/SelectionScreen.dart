import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/TopicCard.dart';
import 'package:mini_quiz/pages/user_side/levelpage.dart';
import 'package:mini_quiz/provider/selectionScreen_provider.dart';
import 'package:provider/provider.dart';

class SelectionScreen extends StatefulWidget {
  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}
class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<SelectionscreenProvider>().fetchCategories(),
    );
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Color(0xFFE88BC3), // pink
      Color(0xFFE0C300), // yellow
      Color(0xFFF39A4D), // orange
      Color(0xFF9BAFE3), // blue
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SelectionscreenProvider>();
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
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Can use between one
                // mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: provider.categories.map((category) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            height: MediaQuery.of(context).size.width / 2 - 40,
                            child: Topiccard(
                              title: category.name,
                              color: _getColor(
                                provider.categories.indexOf(category),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LevelPage(catagoryId: category.id),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
