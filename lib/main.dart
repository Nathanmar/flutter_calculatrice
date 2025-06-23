import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';


void main() => runApp(CalculatriceApp());

class CalculatriceApp extends StatelessWidget {
  const CalculatriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculatrice Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
          labelLarge: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.indigo),
            padding: MaterialStatePropertyAll(EdgeInsets.all(22)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      home: Calculatrice(),
    );
  }
}



class Calculatrice extends StatefulWidget {
  const Calculatrice({super.key});

  @override
  _CalculatriceState createState() => _CalculatriceState();
}

class _CalculatriceState extends State<Calculatrice> {
  String _output = '0';
  String _equation = '';
  String _result = '';

  final List<String> _buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    'C', '0', '=', '+',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _equation = '';
        _result = '';
        _output = '0';
      } else if (value == '=') {
        try {
          _result = _evaluate(_equation);
          _output = _result;
        } catch (e) {
          _output = 'Erreur';
        }
      } else {
        _equation += value;
        _output = _equation;
      }
    });
  }

  String _evaluate(String expr) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Erreur';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculatrice Flutter')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: _buttons.length,
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(_buttons[index]),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttons[index] == '='
                        ? Colors.indigo
                        : Colors.indigo.shade200,
                    padding: EdgeInsets.all(22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _buttons[index],
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
