// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/user_side/view/login_screen.dart';
import 'package:mini_quiz/utill/responsive.dart';
// import 'package:quiz_minidemo/LoginScren.dart';
// import 'package:mini_quiz_demo/Screen/LoginScreen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive container size - fixed sizes work better than percentages for full-screen fit
    final containerSize = R.isDesktop(context)
        ? 250.0
        : R.isTablet(context)
            ? 220.0
            : R.wp(context, 0.65);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome to',
              style: TextStyle(
                fontSize: R.adaptive(context, mobile: 16, tablet: 18, desktop: 18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8C8C8C),
              ),
            ),
            SizedBox(height: R.hp(context, 0.01)),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: R.adaptive(context, mobile: 36, tablet: 40, desktop: 40),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(
                    text: 'mini ',
                    style: TextStyle(
                      color: const Color(0xFF5C5C5C),
                      fontSize: R.adaptive(context, mobile: 22, tablet: 25, desktop: 25),
                    ),
                  ),
                  TextSpan(
                    text: 'Quiz',
                    style: TextStyle(color: const Color(0xFF00D60B)), // Green
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            SizedBox(height: R.hp(context, 0.03)),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: containerSize,
                  height: containerSize,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF40DCCA),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ready for a',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: R.adaptive(context, mobile: 18, tablet: 20, desktop: 18),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                        Text(
                          'Challange?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: R.adaptive(context, mobile: 24, tablet: 27, desktop: 24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5EC0B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -28,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009E08),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Start Quiz",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: R.adaptive(context, mobile: 24, tablet: 26, desktop: 20),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
