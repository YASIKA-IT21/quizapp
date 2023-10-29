import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/result_box.dart';
import '../constants.dart';
import '../widgets/next_button.dart';
import '../widgets/options_card.dart';
import '../models/db_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBConnect();

  late Future _questions;

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  var index = 0;
  bool isPressed = false;
  int score = 0;
  bool isAlreadySelected = false;

  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: questionLength,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please Select any Option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                title: const Text('Quiz App'),
                backgroundColor: Colors.pink,
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Score:$score',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    QuestionWidget(
                      question: extractedData[index].title,
                      totalQuestions: extractedData.length,
                      indexAction: index,
                    ),
                    const Divider(color: neutral),
                    SizedBox(height: 20.0),
                    Image.network('data:image/jpeg;base64,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'), // Replace 'your_image.png' with the actual image path
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3.9,
                        children: List.generate(
                          extractedData[index].options.length,
                          (i) => GestureDetector(
                            onTap: () => checkAnswerAndUpdate(
                                extractedData[index].options.values.toList()[i]),
                            child: OptionCard(
                              option: extractedData[index].options.keys.toList()[i],
                              color: isPressed
                                  ? extractedData[index].options.values.toList()[i] == true
                                      ? correct
                                      : incorrect
                                  : neutral,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0),
                Text(
                  'Please wait till the questions are loading',
                  style: TextStyle(
                    color: Colors.yellow,
                    decoration: TextDecoration.none,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }
}
