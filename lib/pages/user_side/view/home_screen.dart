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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome to',
              style: TextStyle(
                fontSize: R.adaptive(context, mobile: 16, tablet: 18, desktop: 20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8C8C8C),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: R.adaptive(context, mobile: 36, tablet: 40, desktop: 48),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(
                    text: 'mini ',
                    style: TextStyle(
                      color: const Color(0xFF5C5C5C),
                      fontSize: R.adaptive(context, mobile: 22, tablet: 25, desktop: 30),
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
              height: R.hp(context, 0.003),
              width: R.wp(context, 0.25),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(R.wp(context, 0.01)),
              ),
            ),
            SizedBox(height: R.hp(context, 0.04)),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: R.wp(context, 0.65),
                  height: R.wp(context, 0.65),
                  padding: EdgeInsets.all(R.wp(context, 0.05)),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(R.wp(context, 0.10)),
                    border: Border.all(
                      color: const Color(0xFF40DCCA),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ready for a',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: R.adaptive(context, mobile: 18, tablet: 20, desktop: 24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                        Text(
                          'Challange?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: R.adaptive(context, mobile: 24, tablet: 27, desktop: 32),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5EC0B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -R.hp(context, 0.04),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
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
                          horizontal: R.wp(context, 0.10),
                          vertical: R.hp(context, 0.03),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(R.wp(context, 0.05)),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Start Quiz",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: R.adaptive(context, mobile: 24, tablet: 28, desktop: 32),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
