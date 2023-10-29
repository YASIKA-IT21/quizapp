import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required this.option,
    required this.color,
  }) : super(key: key);

  final String option;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: color,
        child: Center(
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: color.computeLuminance() > 0.5 ? Colors.black : Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionGrid extends StatelessWidget {
  final List<String> options;
  final List<Color> colors;

  OptionGrid({
    required this.options,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return OptionCard(
            option: options[index],
            color: colors[index],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Option Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Option Grid'),
        ),
        body: OptionGrid(
          options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
          colors: [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
          ],
        ),
      ),
    );
  }
}
