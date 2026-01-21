import '../../components/layout/admin_sidebar.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Home > ',
                          style: TextStyle(color: Color(0xFF8C8C8C)),
                        ),
                        TextSpan(
                          text: 'Category',
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
                    "Category",
                    style: TextStyle(
                      color: Color(0xFF009E08),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007F06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 150,
                    child: Text(
                      "View Categories",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Add Category",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Category Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007F06),
                                ),
                                child: const Text(
                                  "Add Levels",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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
