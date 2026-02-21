import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';

class Topiccard extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final int categoryId;
  final categoryController = Get.find<CategoryController>();

  Topiccard({required this.title, required this.color, required this.description, required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
