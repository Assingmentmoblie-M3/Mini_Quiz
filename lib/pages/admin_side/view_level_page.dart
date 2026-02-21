import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/admin_side/levels_page.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';
import 'package:mini_quiz/provider/level_provider.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'package:mini_quiz/components/action_button.dart';

class ViewLevelScreen extends StatefulWidget {
  const ViewLevelScreen({super.key});

  @override
  State<ViewLevelScreen> createState() => _ViewLevelScreenState();
}

class _ViewLevelScreenState extends State<ViewLevelScreen> {
  String searchText = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<LevelProvider>(context, listen: false).fetchLevel(),
    );
  }

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
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(color: Color(0xFF8C8C8C)),
                        ),
                        TextSpan(
                          text: 'Levels',
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
                    "Levels",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Fredoka',
                    ),
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LevelsScreen()),
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

                  const SizedBox(height: 15),
                  Expanded(
                    child: SectionCard(
                      title: "Table Levels",
                      onSearchChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
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

class LevelsTable extends StatefulWidget {
  const LevelsTable({super.key});

  @override
  State<LevelsTable> createState() => _LevelsTableState();
}

class _LevelsTableState extends State<LevelsTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
      builder: (context, provider, child) {
        if (provider.isloading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.level.isEmpty) {
          return const Center(child: Text("No Levels Found"));
        }

        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("No.")),
                DataColumn(label: Text("Actions")),
                DataColumn(label: Text("Level Name")),
                DataColumn(label: Text("Description")),
                DataColumn(label: Text("Category")),
                DataColumn(label: Text("Created Date")),
              ],
              rows: List.generate(provider.level.length, (index) {
                final level = provider.level[index];
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}")),
                    DataCell(
                      ActionButtons(
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LevelsScreen(
                                levelId: level['level_id'],
                                levelName: level['level_name'],
                                description: level['description'],
                                categoryId: level['category']?['id'],
                              ),
                            ),
                          );
                        },
                        onDelete: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                "Are you sure you want to delete?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
          
                          if (confirm == true) {
                            await provider.deleteLevel(level['level_id']);
                          }
                        },
                      ),
                    ),
                    DataCell(Text(level['level_name'] ?? "")),
                    DataCell(Text(level['description'] ?? "")),
                    DataCell(Text(level['category']?['name'] ?? "")),
                    DataCell(Text(level['created_at'] ?? "")),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
