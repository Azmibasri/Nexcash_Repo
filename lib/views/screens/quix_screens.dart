import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import 'home_screens.dart';
import 'xp_reward_screen.dart';

class QuixScreens extends StatefulWidget {
  const QuixScreens({super.key});

  @override
  State<QuixScreens> createState() => _QuixScreensState();
}

class _QuixScreensState extends State<QuixScreens> {
  final List<Question> _quizQuestions = nexCashQuestions;
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  int? _selectedOptionIndex;
  int _score = 0;
  int _lives = 5;
  int _totalXp = 0;

  void onClick(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    }
  }

  void _answerQuestion(String option, int index) {
    setState(() {
      _selectedOption = option;
      _selectedOptionIndex = index;
    });
  }

  void _nextQuestion() {
    if (_selectedOptionIndex ==
        _quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
      _totalXp += 10;
    } else {
      _lives--;
      if (_lives <= 0) {
        _showGameOverDialog();
        return;
      }
    }

    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _selectedOptionIndex = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _lives = 5;
      _totalXp = 0;
      _selectedOption = null;
      _selectedOptionIndex = null;
    });
  }

  // BUG FIX: Menghapus deklarasi fungsi ganda
  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Kuis Selesai!'),
        content: Text('Skor Anda: $_score dari ${_quizQuestions.length} soal.'),
        actions: <Widget>[
          if (_score > 5)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => XpRewardScreen(totalXp: _totalXp),
                  ),
                );
                // _resetQuiz(); // <--- HAPUS BARIS INI
              },
              child: const Text('Klaim Hadiah XP'),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _resetQuiz(); // Biarkan ini di sini untuk tombol "Ulangi Kuis"
              },
              child: const Text('Ulangi Kuis'),
            ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Game Over!'),
        content: const Text('Nyawa Anda habis. Coba lagi!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _resetQuiz();
            },
            child: const Text('Mulai Ulang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _quizQuestions[_currentQuestionIndex];
    const Color mainBackgroundColor = Colors.white;
    const Color primaryTextColor = Color(0xFF19183B);
    const Color progressBarValueColor = Colors.orange;
    const Color checkButtonColor = Color(0xFFA1A1A1);
    const Color optionButtonColor = Color(0xFF19183B);
    const Color selectedOptionColor = Color(0xFF5E5E7E);

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryTextColor, size: 30),
          onPressed: () => onClick(1),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Opacity(
                opacity: index < _lives ? 1.0 : 0.3,
                child: Image.asset('assets/heart.png', width: 30, height: 30),
              ),
            );
          }),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Question ${_currentQuestionIndex + 1} out of ${_quizQuestions.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF888888), fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _quizQuestions.length,
                    backgroundColor: mainBackgroundColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      progressBarValueColor,
                    ),
                    minHeight: 10,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        currentQuestion.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ...List.generate(currentQuestion.options.length, (index) {
                        final option = currentQuestion.options[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 65,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _answerQuestion(option, index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedOption == option
                                    ? selectedOptionColor
                                    : optionButtonColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black26,
                              ),
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _selectedOption != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedOption != null
                      ? checkButtonColor
                      : Colors.grey,
                  foregroundColor: primaryTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
