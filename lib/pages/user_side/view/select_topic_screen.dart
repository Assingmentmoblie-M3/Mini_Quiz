import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/user_side/components/topic_card.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';
// Import your next page
import 'package:mini_quiz/pages/user_side/view/level_screen.dart';

const List<Color> topicColors = [
  Color(0xFFFF98D2),
  Color(0xFFDDCA00),
  Color(0xFFFFA158),
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

class SelectionScreen extends StatefulWidget {
  SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    // Ensure categories are fetched when this screen appears
    Future.microtask(() => categoryController.fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
            SizedBox(height: 40),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (categoryController.categories.isEmpty) {
                  return Center(
                    child: Text(
                      "No categories available",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    final boxColor = topicColors[index % topicColors.length];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the next page for this category
                        Get.to(() => LevelPage(categoryId: category.categoryId));
                      },
                      child: Topiccard(
                        title: category.categoryName,
                        color: boxColor,
                        categoryId: category.categoryId,
                        description: category.description,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}