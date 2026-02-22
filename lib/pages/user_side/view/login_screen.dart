import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_quiz/pages/user_side/view/select_topic_screen.dart';
import 'package:mini_quiz/pages/admin_side/controller/user_controller.dart';
import 'package:mini_quiz/pages/admin_side/model/user_model.dart';
import 'package:mini_quiz/pages/admin_side/view/admin_dashboard_page.dart';
import 'package:mini_quiz/utill/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }

  // Future<void> _handleLogin() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   final email = emailController.text.trim().toLowerCase();
  //   Get.dialog(
  //     const Center(child: CircularProgressIndicator()),
  //     barrierDismissible: false,
  //   );

  //   try {
  //     // Try to find existing user
  //     User? user = userController.users.firstWhere(
  //       (u) => u.email.toLowerCase() == email,
  //       orElse: () => User(
  //         userId: 0,
  //         email: email,
  //         roleId: 0,
  //         status: true,
  //         createdAt: DateTime.now(),
  //       ),
  //     );

  //     // If new, create it
  //     if (user.userId == 0) {
  //       user = await userController.addUser(email) ?? user;
  //     }

  //     Get.back(); // close loading

  //     // Navigate based on role
  //     if (user.roleId == 0) {
  //       Get.to(() => SelectionScreen());
  //     }
  //     if (user.roleId == 1) {
  //       Get.to(() => DashboardScreen());
  //     }
  //   } catch (e) {
  //     Get.back();
  //     Get.snackbar(
  //       'Error',
  //       'Something went wrong',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  late final UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.put(UserController());
  }

  @override
  Widget build(BuildContext context) {
    // final userController = Get.put(UserController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chevron_back),
          color: Colors.green,
          iconSize: R.scaleWidth(7),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: R.wp(context, 0.05),
          vertical: R.wp(context, 0.05),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Your Email",
                      style: TextStyle(
                        fontSize: R.adaptive(context, mobile: 28, tablet: 32, desktop: 36),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00D60B),
                      ),
                    ),
                    SizedBox(height: R.hp(context, 0.02)),
                    Text(
                      "We'll only use this to save your program!\nWe won't spam you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: R.adaptive(context, mobile: 13, tablet: 15, desktop: 17),
                        color: const Color(0xFF5C5C5C),
                      ),
                    ),
                    SizedBox(height: R.hp(context, 0.04)),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF8C8C8C),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: R.hp(context, 0.025),
                          horizontal: R.wp(context, 0.08),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(R.wp(context, 0.05)),
                          borderSide: const BorderSide(
                            color: Color(0xFF40DCCA),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(R.wp(context, 0.05)),
                        ),
                      ),
                      validator: _emailValidator,
                    ),
                  ],
                ),
              ),
              Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  height: R.hp(context, 0.08),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Prevent double clicks
                      if (userController.isLoading.value) return;

                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text
                            .trim()
                            .toLowerCase();

                        final user = await userController.login(email);

                        if (user != null) {
                          if (user.roleId == 0) {
                            Get.off(() => SelectionScreen());
                          } else if (user.roleId == 1) {
                            Get.off(() => DashboardScreen());
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A408),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(R.wp(context, 0.04)),
                      ),
                    ),
                    child: userController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: R.adaptive(context, mobile: 16, tablet: 18, desktop: 20),
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
