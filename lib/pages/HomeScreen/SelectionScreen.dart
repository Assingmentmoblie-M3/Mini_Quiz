import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/TopicCard.dart';
// import 'package:quiz_minidemo/TopicCard.dart';
// import 'package:mini_quiz_demo/Screen/TopicCard.dart';

class SelectionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {'title': 'General Knowledge', 'color': Color(0xFFF4A1D2)},
    {'title': 'Math', 'color': Color(0xFFD4CC46)},
    {'title': 'English', 'color': Color(0xFFF7AC6F)},
    {'title': 'Technology', 'color': Color(0xFFB5C0F9)},
  ];

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
      body: Padding(
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
                color: Colors.green.shade400,
              ),
            ),
            Text(
              "Choose your topic!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Topiccard(
                    title: topics[index]['title'],
                    color: topics[index]['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
