import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';



void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '0';
  String _outputHistory = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _outputHistory = '';
      } else if (buttonText == 'DEL') {
        _output = _output.substring(0, _output.length - 1);
        if (_output.isEmpty) _output = '0';
      } else if (buttonText == '=') {
        try {
          final result = evaluate(_output);
          _outputHistory = _output;
          _output = result.toString();
        } catch (e) {
          _output = 'Error';
        }
      } else {
        if (_output == '0' || _output == 'Error') {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gabijan\'s Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _outputHistory,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    _output,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black12,
              child: Column(
                children: [
                  buildButtonRow(['7', '8', '9', '/']),
                  buildButtonRow(['4', '5', '6', '*']),
                  buildButtonRow(['1', '2', '3', '-']),
                  buildButtonRow(['.', '0', 'C', '+']),
                  buildButtonRow(['DEL', '=', '', '']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((buttonText) {
          return Expanded(
            child: TextButton(
              onPressed: () => _buttonPressed(buttonText),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// double evaluate(String expression) {
//   return math.evaluate(expression);
// }


double evaluate(String expression) {
  Parser p = Parser();
  Expression exp = p.parse(expression);
  ContextModel cm = ContextModel();
  return exp.evaluate(EvaluationType.REAL, cm);
}
