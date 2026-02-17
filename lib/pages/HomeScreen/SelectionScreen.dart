import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/HomeScreen/HomeScreen.dart';
import 'package:mini_quiz/pages/HomeScreen/TopicCard.dart';
import 'package:mini_quiz/provider/selectionScreen_provider.dart';
import 'package:provider/provider.dart';
// import 'package:quiz_minidemo/TopicCard.dart';
// import 'package:mini_quiz_demo/Screen/TopicCard.dart';

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
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return Topiccard(
                          title: category.name,
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Homescreen(
                                  /*categoryId: category.id,
                                  categoryName: category.name,*/
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
            ),
    );
  }
}
