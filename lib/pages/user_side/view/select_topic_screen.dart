import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/user_side/components/topic_card.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';
// Import your next page
import 'package:mini_quiz/pages/user_side/view/level_screen.dart';
import 'package:mini_quiz/services/local_storage_service.dart';
import 'package:mini_quiz/utill/responsive.dart';

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
      // appBar: AppBar(),
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: R.wp(context, 0.06)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quiz",
                style: TextStyle(
                  fontSize: R.adaptive(context, mobile: 44, tablet: 48, desktop: 56),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00D60B),
                ),
              ),
              Text(
                "Choose your topic!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: R.adaptive(context, mobile: 18, tablet: 20, desktop: 24),
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              SizedBox(height: R.hp(context, 0.05)),
              Expanded(
                child: Obx(() {
                  if (categoryController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  if (categoryController.categories.isEmpty) {
                    return Center(
                      child: Text(
                        "No categories available",
                        style: TextStyle(
                          fontSize: R.adaptive(context, mobile: 14, tablet: 16, desktop: 18),
                        ),
                      ),
                    );
                  }
        
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: R.isTablet(context) ? 3 : 2,
                      crossAxisSpacing: R.wp(context, 0.05),
                      mainAxisSpacing: R.wp(context, 0.05),
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categories[index];
                      final boxColor = topicColors[index % topicColors.length];
        
                      return GestureDetector(
                        onTap: () {
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
      ),
    );
  }
}