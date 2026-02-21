import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_quiz/pages/user_side/result.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';

class Quiz_QCM1 extends StatefulWidget {
  final int categoryId;
  final int levelId;
  // លុប question ចេញពី constructor ព្រោះយើងទាញពី Provider
  const Quiz_QCM1({super.key, required this.categoryId, required this.levelId, required Map<dynamic, dynamic> question});

  @override
  State<Quiz_QCM1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<Quiz_QCM1> {
  int? selectedIndex;
  static const int totalSeconds = 60;
  int remainingSeconds = totalSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    // មិនបាច់ fetchQuestions នៅទីនេះទៀតទេ ព្រោះ QuizMainScreen ធ្វើរួចហើយ
  }

  void startTimer() {
    timer?.cancel();
    remainingSeconds = totalSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        goNext();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void goNext() {
    final provider = context.read<QuizProvider>();

    // បញ្ជូនចម្លើយទៅឆែក (SelectedIndex បើអត់រើស គឺ -1)
    provider.checkAnswer([selectedIndex ?? -1]);

    if (provider.isLastQuestion) {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPages(
            score: provider.score,
            total: provider.questions.length,
          ),
        ),
      );
    } else {
      provider.nextQuestion();
      setState(() {
        selectedIndex = null; // Reset ការរើស
      });
      startTimer(); // Reset Timer ឡើងវិញ
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // 👈 ទាញ Data ស្រស់ៗពី Provider ក្នុង Build តែម្តង
    final provider = context.watch<QuizProvider>();
    final currentQ = provider.currentQuestion;

    if (currentQ.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // រៀបចំបញ្ជីចម្លើយ
    final List answersFromDB = currentQ['answers'] ?? [];
    List options = [];
    if (answersFromDB.isNotEmpty) {
      final data = answersFromDB[0];
      options = [
        data['answer_a'] ?? "",
        data['answer_b'] ?? "",
        data['answer_c'] ?? "",
        data['answer_d'] ?? "",
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quiz', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF19A191))),
                  Text(
                    '${formatTime(remainingSeconds)}\n'
                    '${provider.currentIndex + 1}/${provider.questions.length}',
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// QUESTION CARD
              _questionCard(currentQ['question'] ?? ""),
              const SizedBox(height: 24),

              /// OPTIONS
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) => _optionTile(
                    text: options[index],
                    selected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),

              /// NEXT BUTTON
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedIndex == null ? null : goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19A191),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: const Color(0xFF19A191), borderRadius: BorderRadius.circular(35)),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
    );
  }

  Widget _optionTile({required String text, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFF00D60B) : const Color(0xFFB2DFDB), width: 2),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF19A191))),
      ),
    );
  }
}
/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';

class Quiz_QCM1 extends StatefulWidget {
    final int categoryId;
  final int levelId;

  const Quiz_QCM1({
    super.key,
    required this.categoryId,
    required this.levelId,
  });
  //const Quiz_QCM1({super.key, required int categoryId, required int levelId});

  @override
  State<Quiz_QCM1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<Quiz_QCM1> {
  int? selectedIndex;

  // ===== TIMER =====
  static const int totalSeconds = 60; //  change to 1 minute
  int remainingSeconds = totalSeconds;
  Timer? timer;

  final List<String> answers = [
    'A. Yes, I am',
    'B. Yes, I am sure',
    'C. Because I am gay',
    'D. Yes, I am',
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
      Future.microtask(() =>
    context.read<QuizProvider>()
      .fetchQuestions(widget.categoryId, widget.levelId)
  );
  }


  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds == 0) {
        t.cancel();
        Navigator.pushNamed(context, '/q2');
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header('1/5'),
              const SizedBox(height: 20),
              _questionCard('Q1. \nWhy are you gay????'),
              const SizedBox(height: 24),

              // Answers
              ...List.generate(
                answers.length,
                (index) => _optionTile(
                  text: answers[index],
                  selected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),

              const Spacer(),

              // Next Button
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          timer?.cancel();
                          Navigator.pushNamed(context, '/q2');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19A191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets =====

  Widget _header(String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quiz #1',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF19A191),
          ),
        ),
        Text(
          '${formatTime(remainingSeconds)}\n$step',
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _questionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF19A191),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _optionTile({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    // កំណត់ពណ៌បៃតងដែលអ្នកចង់បាន
    final Color primaryGreen = const Color(0xFF19A191);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        // បន្ថែម padding ខាងឆ្វេង (horizontal: 20) ដើម្បីឱ្យអក្សរ A, B, C មើលទៅស្អាត
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF00D60B) // ពណ៌បៃតងភ្លឺពេល Select
                : const Color(0xFFB2DFDB), // ពណ៌បៃតងស្រាលពេលមិនទាន់ Select
            width: 2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:mini_quiz/provider/quiz1_provider.dart';
import 'package:provider/provider.dart';

class Quiz_QCM1 extends StatefulWidget {
  final int categoryId;
  final int levelId;

  const Quiz_QCM1({super.key, required this.categoryId, required this.levelId});

  @override
  State<Quiz_QCM1> createState() => _Quiz_QCM1State();
}

class _Quiz_QCM1State extends State<Quiz_QCM1> {
  int currentIndex = 0;
  int? selectedIndex;

   @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuizProvider>().fetchQuestions(
        widget.categoryId,
        widget.levelId,
      );
    });
  }
  void nextQuestion(QuizProvider provider) {
    if (currentIndex < provider.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.questions.isEmpty) {
            return const Center(child: Text("No questions found"));
          }

          if (currentIndex >= provider.questions.length) {
            currentIndex = 0;
          }

          final question = provider.questions[currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Question ${currentIndex + 1}/${provider.questions.length}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ...List.generate(
                  question.answers.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == index
                              ? Colors.green
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(question.answers[index]),
                    ),
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () => nextQuestion(provider),
                  child: const Text("Next"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
