import 'package:get/get.dart';
import 'package:mini_quiz/components/action_button.dart';
import 'package:mini_quiz/pages/admin_side/answer_page.dart';
import 'package:mini_quiz/pages/admin_side/controller/level_controller.dart';
import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import './levels_page.dart';

class ViewLevelScreen extends StatefulWidget {
  const ViewLevelScreen({super.key});

  @override
  State<ViewLevelScreen> createState() => _ViewLevelScreenState();
}

class _ViewLevelScreenState extends State<ViewLevelScreen> {
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Levels"),

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
                          style: TextStyle(color: Color(0xFF8C8C8C)),
                        ),
                        TextSpan(
                          text: 'Levels',
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Levels",
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
                          levelController.resetForm();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LevelsScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007F06),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Add New Level",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Levels",
                      onSearchChanged: (value) {
                        levelController.searchLevels(value);
                      },
                      searchHint: "Search levels...",
                      child: const LevelsTable(),
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

final levelController = Get.put(LevelController());
class LevelsTable extends StatefulWidget {
  const LevelsTable({super.key});
  @override
  State<LevelsTable> createState() => _LevelsTableState();
}

class _LevelsTableState extends State<LevelsTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //const LevelSearchBox(),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => DataTable(
              columns: const [
                DataColumn(
                  label: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    
                      child: Text(
                        "No.",
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
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    
                      child: Text(
                        "Level",
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
                        "Category",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E5E5E),
                        ),
                      
                    ),
                  ),
                ),
                DataColumn(
                  label: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 0),
                    
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
              rows: levelController.filteredLevels.map((level) {
                final index = levelController.filteredLevels.indexOf(level) + 1;
                return DataRow(
                  cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(index.toString()),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ActionButtons(
                          onEdit: () {
                            levelController.startEdit(
                              level.levelId,
                              level.levelName,
                              level.description,
                              level.category.categoryId,
                            );
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LevelsScreen()),
                            );
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                  "Are you sure deleting level?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      levelController.deleteLevel(level.levelId);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child:  Text(level.levelName),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(level.description),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(level.category.categoryName),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),

                        child: Text(level.createdAt.toIso8601String().split('T')[0]),

                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
