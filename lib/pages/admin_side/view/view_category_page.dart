import 'package:get/get.dart';
import 'package:mini_quiz/pages/admin_side/controller/category_controller.dart';

import '../../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'category_page.dart';
import 'package:mini_quiz/components/action_button.dart';

class ViewCategoryScreen extends StatefulWidget {
  const ViewCategoryScreen({super.key});
  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Category"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                        TextSpan(
                          text: 'Category',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Category",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          categoryController.resetForm();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const CategoryScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Add New Category",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Category",
                      onSearchChanged: (value) {
                        categoryController.searchCategories(value);
                      },
                      searchHint: "Search category...",
                      child: const CategoryTable(),
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

class CategoryTable extends StatefulWidget {
  const CategoryTable({super.key});

  @override
  State<CategoryTable> createState() => _CategoryTableState();
}

final categoryController = Get.put(CategoryController());

class _CategoryTableState extends State<CategoryTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Obx(
          () => DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  "No.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E5E5E),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
      
                  child: Text(
                    "Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
      
                  child: Text(
                    "Category Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
      
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
      
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
      
                  child: Text(
                    "Created At",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ),
            ],
      
            rows: categoryController.filteredCategories.map((category) {
              // print(category);
              final index =
                  categoryController.filteredCategories.indexOf(category) + 1;
              return DataRow(
                cells: [
                  // ID
                  DataCell(Text(index.toString())),
      
                  // Action buttons
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: ActionButtons(
                        onEdit: () {
                          categoryController.startEdit(
                            category.categoryId,
                            category.categoryName,
                            category.description,
                          );
      
                          categoryNameController.text = category.categoryName;
                          descriptionController.text = category.description;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryScreen(
                                // pass category if needed
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Are you sure deleting category?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // print(category.categoryId);
                                    categoryController.deleteCategory(
                                      category.categoryId,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      
                  // Category name
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(category.categoryName),
                    ),
                  ),
      
                  // Description
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(category.description),
                    ),
                  ),
      
                  DataCell(
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        category.createdAt.toIso8601String().split('T')[0],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
