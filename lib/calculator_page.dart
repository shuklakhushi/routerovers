import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calculator',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            CalculatorWidget(), //display the CalculatorWidget
          ],
        ),
      ),
    );
  }
}

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _expression = ''; //used to store the user input
  String _result = ''; //used to store the result

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        _evaluateExpression();
      } else {
        _expression += value;
      }
    });
  }

  void _evaluateExpression() {
    Parser p = Parser();
    Expression exp = p.parse(_expression);
    ContextModel cm = ContextModel();

    try {
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      _result = evalResult.toString();
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            _expression,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            _result,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20), 
          Row( //display the numeric and operators buttons in a row
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCalcButton('7'),
              buildCalcButton('8'),
              buildCalcButton('9'),
              buildCalcButton('/'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCalcButton('4'),
              buildCalcButton('5'),
              buildCalcButton('6'),
              buildCalcButton('*'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCalcButton('1'),
              buildCalcButton('2'),
              buildCalcButton('3'),
              buildCalcButton('+'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCalcButton('='),
              buildCalcButton('0'),
              buildCalcButton('C'),
              buildCalcButton('-'),
            ],
          ),
         
        ],
      ),
    );
  }

  Widget buildCalcButton(String label) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(label),
      child: Text(label),
    );
  }
}
