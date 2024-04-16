import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  //mag initialize sa output ug history
  String _output = '0';
  String _outputHistory = '';

  //logic here, manual ang C, DEl ug %. ang = naggamit ug math library
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
      } else if (buttonText == '%') {
        try {
          final result = evaluate('$_output / 100');
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
        title: const Text('Gabijan\'s Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _outputHistory,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 202, 202, 202)),
                  ),
                  Text(
                    _output,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(31, 124, 124, 124),
              child: Column(
                children: [
                  for (final buttonRow in [
                    ['C', '/', '*', 'DEL'],
                    ['7', '8', '9', '-'],
                    ['4', '5', '6', '+'],
                    ['1', '2', '3', '='],
                    ['%', '0', '.', ''],
                  ])
                    buildButtonRow(buttonRow),
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
        children: buttons.asMap().entries.map((entry) {
          final buttonText = entry.value;
          return Expanded(
            child: TextButton(
              onPressed: () => _buttonPressed(buttonText),
              // = nga mods sa background color
              style: TextButton.styleFrom(
                backgroundColor: buttonText == '=' ? Colors.amber : null,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(buttonText == '=' ? 0.0 : 0.0),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 24,
                  color: _getButtonColor(buttonText),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//customize color
  Color _getButtonColor(String buttonText) {
    switch (buttonText) {
      case '/':
      case '-':
      case '*':
      case 'DEL':
      case '+':
        return Colors.amber;
      default:
        return Colors.white;
    }
  }
}

double evaluate(String expression) {
  final p = Parser();
  final exp = p.parse(expression);
  final cm = ContextModel();
  return exp.evaluate(EvaluationType.REAL, cm);
}
