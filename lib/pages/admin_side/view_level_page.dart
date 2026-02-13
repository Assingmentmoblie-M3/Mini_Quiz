import 'package:mini_quiz/provider/category_provider.dart';
import 'package:provider/provider.dart';
import '../../layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/components/section_card.dart';
import 'category_page.dart';

class ViewLevelScreen extends StatefulWidget {
  const ViewCategoryScreen({super.key});
  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
  String searchText = "";
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).fetchCategories(),
    );
  }

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
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CategoryScreen(),
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
                        setState(() {
                          searchText = value;
                        });
                      },
                      searchHint: "Search category...",
                      child: LevelTable(),
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


class LevelTable extends StatefulWidget {
  const LevelTable({super.key});

  @override
  State<LevelTable> createState() => _LevelTableState();
}

class _LevelTableState extends State<LevelTable> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(selected: "Levels"),
          Expanded(
            child: Consumer<LevelProvider>(
              builder: (context, provider, child) {
                if (provider.isloading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.level.isEmpty) {
                  return const Center(child: Text("No Levels Found"));
                }

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("No.")),
                      DataColumn(label: Text("Level Name")),
                      DataColumn(label: Text("Description")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: List.generate(provider.level.length, (index) {
                      final level = provider.level[index];
                      return DataRow(cells: [
                        DataCell(Text("${index + 1}")),
                        DataCell(Text(level['level_name'] ?? "")),
                        DataCell(Text(level['description'] ?? "")),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LevelsScreen(
                                      levelId: level['level_id'],
                                      levelName: level['level_name'],
                                      description: level['description'],
                                      categoryId: level['category']['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                bool? confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        "Are you sure you want to delete?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await provider
                                      .deleteLevel(level['level_id']);
                                }
                              },
                            ),
                          ],
                        )),
                      ]);
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
