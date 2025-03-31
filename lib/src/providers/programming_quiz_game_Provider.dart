import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/common/widget/game_over_dialog.dart';
import 'package:game_flutter/src/common/widget/game_win_dialog.dart';
import 'package:provider/provider.dart';
import 'package:game_flutter/src/providers/history_provider.dart';
import 'package:game_flutter/src/providers/level_provider.dart';
import 'package:http/http.dart' as http;

class ProgrammingQuizGameProvider with ChangeNotifier {
  late int total;
  late int count;
  late int questionTime;
  late int initialTimeLimit;
  late List<Map<String, dynamic>> questionBank;
  List<int> listNumber =
      []; // Khởi tạo mặc định để tránh LateInitializationError
  late StreamController<int> streamController;
  late StreamController<int> questionTimerController;
  late TextEditingController nameController;
  Timer? timer;
  Timer? questionTimer;
  int core = 0;
  int currentQuestionIndex = 0;
  String currentQuestion = "";
  int correctAnswer = 0;
  bool _isInitialized = false;
  bool _isLoadingQuestions = false; // Trạng thái tải câu hỏi từ API
  final int maxQuestions = 10;
  final String geminiApiKey = "AIzaSyABnCsYvp5LU7OYfCcaLp2xBd2Gv097Kgo";

  bool get isInitialized => _isInitialized;
  bool get isLoadingQuestions => _isLoadingQuestions;
  Stream<int> get timeStream => streamController.stream;
  Stream<int> get questionTimeStream => questionTimerController.stream;

  ProgrammingQuizGameProvider() {
    streamController = StreamController<int>.broadcast();
    questionTimerController = StreamController<int>.broadcast();
    nameController = TextEditingController();
    _initializeQuestionBank();
  }

  void _initializeQuestionBank() {
    questionBank = [
      {
        "question": "What is the output of: print(2 + 3 * 4)?",
        "options": [14, 20, 12, 18],
        "correct": 14,
      },
      {
        "question": "What does this function do: `len()` in Python?",
        "options": [0, 1, 2, 3],
        "optionsText": [
          "Returns length",
          "Prints text",
          "Adds numbers",
          "Loops",
        ],
        "correct": 0,
      },
      {
        "question": "What is the time complexity of a binary search?",
        "options": [0, 1, 2, 3],
        "optionsText": ["O(n)", "O(log n)", "O(n^2)", "O(1)"],
        "correct": 1,
      },
      {
        "question": "What is the output of: `int x = 5; x++;` in C?",
        "options": [5, 6, 4, 7],
        "correct": 6,
      },
      {
        "question": "What keyword is used to define a function in Python?",
        "options": [0, 1, 2, 3],
        "optionsText": ["func", "def", "function", "define"],
        "correct": 1,
      },
      {
        "question":
            "What is the output of: `for i in range(3): print(i)` in Python?",
        "options": [0, 1, 2, 3],
        "optionsText": ["0 1 2", "1 2 3", "0 1", "1 2"],
        "correct": 0,
      },
      {
        "question": "What does `&&` mean in most programming languages?",
        "options": [0, 1, 2, 3],
        "optionsText": ["OR", "AND", "NOT", "XOR"],
        "correct": 1,
      },
      {
        "question": "What is the default value of a boolean in Java?",
        "options": [0, 1, 2, 3],
        "optionsText": ["true", "false", "null", "0"],
        "correct": 1,
      },
      {
        "question":
            "What is the output of: `console.log(typeof null)` in JavaScript?",
        "options": [0, 1, 2, 3],
        "optionsText": ["null", "object", "undefined", "string"],
        "correct": 1,
      },
      {
        "question": "What does `break` do in a loop?",
        "options": [0, 1, 2, 3],
        "optionsText": [
          "Skips iteration",
          "Exits loop",
          "Restarts loop",
          "Pauses loop",
        ],
        "correct": 1,
      },
    ];
  }

  Future<void> fetchQuestionsFromGemini() async {
    _isLoadingQuestions = true;
    notifyListeners();

    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$geminiApiKey";
    final prompt = """
    Create a programming quiz question with the following format:
    - A question about programming (e.g., code output, concept, syntax).
    - 4 answer options, where only 1 is correct.
    - If the options are text-based (not numbers), provide an "optionsText" field.
    - Specify the correct answer as the index (0-3) of the correct option.
    Return the result in JSON format. Example:
    {
      "question": "What is the output of: print(2 + 3 * 4)?",
      "options": [14, 20, 12, 18],
      "correct": 14
    }
    OR
    {
      "question": "What does this function do: `len()` in Python?",
      "options": [0, 1, 2, 3],
      "optionsText": ["Returns length", "Prints text", "Adds numbers", "Loops"],
      "correct": 0
    }
    Generate 5 new questions.
    """;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText =
            data["candidates"][0]["content"]["parts"][0]["text"];
        final newQuestions = jsonDecode(generatedText) as List<dynamic>;
        questionBank.addAll(newQuestions.cast<Map<String, dynamic>>());
      } else {
        print("Failed to fetch questions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  void start(BuildContext context) async {
    if (_isInitialized) return;
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    total = 4;
    count = levelProvider.timeLimit;
    initialTimeLimit = levelProvider.timeLimit;
    questionTime = 10;
    currentQuestionIndex = 0;

    // Đảm bảo listNumber có giá trị mặc định trước khi gọi API
    listNumber =
        questionBank.isNotEmpty ? List.from(questionBank[0]["options"]) : [];

    await fetchQuestionsFromGemini();
    _loadQuestion();
    runTimer(context);
    runQuestionTimer(context);
    _isInitialized = true;
    notifyListeners();
  }

  void reset(BuildContext? context) {
    _isInitialized = false;
    timer?.cancel();
    questionTimer?.cancel();
    streamController.close();
    questionTimerController.close();
    streamController = StreamController<int>.broadcast();
    questionTimerController = StreamController<int>.broadcast();
    core = 0;
    currentQuestionIndex = 0;
    questionTime = 10;
    listNumber = [];
    notifyListeners();
    if (context != null) start(context);
  }

  void runTimer(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (count > 0) {
        count--;
        streamController.add(count);
      } else {
        endGame(context);
      }
    });
  }

  void runQuestionTimer(BuildContext context) {
    questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (questionTime > 0) {
        questionTime--;
        questionTimerController.add(questionTime);
      } else {
        endGame(context);
      }
    });
  }

  void handleClick(int index, BuildContext context) {
    if (index == questionBank[currentQuestionIndex]["correct"]) {
      core += 20;
      currentQuestionIndex++;
      if (currentQuestionIndex >= maxQuestions) {
        winGame(context);
      } else {
        questionTime = 10;
        _loadQuestion();
      }
    } else {
      endGame(context);
    }
    notifyListeners();
  }

  void _loadQuestion() {
    if (questionBank.isEmpty) {
      currentQuestion = "No questions available";
      listNumber = [0, 0, 0, 0]; // Giá trị mặc định
      return;
    }

    if (currentQuestionIndex < questionBank.length) {
      currentQuestion = questionBank[currentQuestionIndex]["question"];
      listNumber = List.from(questionBank[currentQuestionIndex]["options"]);
    } else {
      currentQuestionIndex = 0;
      currentQuestion = questionBank[currentQuestionIndex]["question"];
      listNumber = List.from(questionBank[currentQuestionIndex]["options"]);
    }
    notifyListeners();
  }

  void endGame(BuildContext context) {
    timer?.cancel();
    questionTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GameOverDialog(
            score: core,
            nameController: nameController,
            onSave: () => saveGame(context),
            onTryAgain: () {
              Navigator.pop(context);
              Navigator.pop(context);
              reset(context);
            },
          ),
    );
  }

  void winGame(BuildContext context) {
    timer?.cancel();
    questionTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GameWinDialog(
            score: core,
            nameController: nameController,
            onSave: () => saveGame(context),
            onPlayAgain: () {
              Navigator.pop(context);
              Navigator.pop(context);
              reset(context);
            },
          ),
    );
  }

  void saveGame(BuildContext context) {
    if (nameController.text.isEmpty) return;
    final newScore = {
      "name": nameController.text,
      "score": core,
      "time": initialTimeLimit - count,
      "mode": "programmingQuiz",
    };
    Provider.of<HistoryProvider>(context, listen: false).addScore(newScore);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    streamController.close();
    questionTimerController.close();
    nameController.dispose();
    timer?.cancel();
    questionTimer?.cancel();
    super.dispose();
  }
}
