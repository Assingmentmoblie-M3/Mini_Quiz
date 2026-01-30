import 'package:flutter/material.dart';
import 'package:mini_quiz/layout/admin_sidebar.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  String? selectedCategory;
  final List<String> categories = [
    'Math',
    'Science',
    'English',
    'General Knowledge',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Row(
        children: [
          const Sidebar(selected: "Levels"),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Home > ",
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Levels",
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Levels
                  const SizedBox(height: 10),
                  const Text(
                    "Levels",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //View Levels
                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007F06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "View Levels",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  //box of information
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Levels",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Filed Levels Name
                          SizedBox(
                            width: 500,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Levels Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),

                          //Levels
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            width: 500,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          //DropdownButtonForm
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            width: 500,
                            child: DropdownButtonFormField<String>(
                              value: selectedCategory,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: const Text('Choose category'),
                              items: categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select category'
                                  : null,
                            ),
                          ),
                          const SizedBox(height:20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007F06),
                                ),
                                child: const Text(
                                  "Add Category",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
