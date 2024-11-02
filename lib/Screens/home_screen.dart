import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../Widgets/calculator_button.dart';
import '../Widgets/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Calculator',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: toggleDarkMode,
          ),
          IconButton(
            icon: Icon(showAdvancedCalculator
                ? Icons.calculate_outlined
                : Icons.calculate),
            onPressed: toggleCalculatorType,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
      body: Column(
        children: [
          displayField(input, isInput: true),
          displayField(output, isInput: false),
          Expanded(
            flex: 5,
            child: GridView.builder(
              itemCount: showAdvancedCalculator
                  ? symbolsBasic.length
                  : symbolsAdvanced.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: showAdvancedCalculator ? 4 : 5,
              ),
              itemBuilder: (context, index) {
                final symbols =
                    showAdvancedCalculator ? symbolsBasic : symbolsAdvanced;
                return CalculatorButton(
                  symbol: symbols[index],
                  onPressed: () => onButtonPressed(symbols[index]),
                  isDarkMode: isDarkMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget displayField(String text, {required bool isInput}) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleCalculatorType() {
    setState(() {
      showAdvancedCalculator = !showAdvancedCalculator;
    });
  }

  void onButtonPressed(String symbol) {
    setState(() {
      if (symbol == 'C') {
        input = '';
        output = '';
      } else if (symbol == 'Del') {
        if (input.isNotEmpty) {
          List<String> functions = [
            'sin(',
            'cos(',
            'tan(',
            'log(',
            'ln(',
            'sin⁻¹(',
            'cos⁻¹(',
            'tan⁻¹(',
            '√('
          ];
          bool foundFunction = false;
          for (String func in functions) {
            if (input.endsWith(func)) {
              input = input.substring(0, input.length - func.length);
              foundFunction = true;
              break;
            }
          }
          if (!foundFunction) {
            input = input.substring(0, input.length - 1);
          }
        }
      } else if (symbol == 'Ans') {
        input = output;
        output = '';
      } else if (symbol == '=') {
        calculateResult();
      } else if (operations.contains(symbol)) {
        if (input.isNotEmpty && operations.contains(input[input.length - 1])) {
          input = input.substring(0, input.length - 1) + symbol;
        } else {
          input += symbol;
        }
      } else if (symbol == '√') {
        input += '√';
      } else if (['sin', 'cos', 'tan', 'log', 'ln'].contains(symbol)) {
        input += '$symbol(';
      } else if (['sin⁻¹', 'cos⁻¹', 'tan⁻¹'].contains(symbol)) {
        input += '$symbol(';
      } else if (symbol == '.') {
        if (!input.endsWith('.')) {
          input += symbol;
        }
      } else {
        input += symbol;
      }
    });
  }

  void calculateResult() {
    try {
      String processedInput = processScientificFunctions(input);
      Expression exp = Parser().parse(processedInput);
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());
      output = result.toString();
    } catch (e) {
      output = 'Error';
    }
  }

  String processScientificFunctions(String input) {
    input = input.replaceAllMapped(RegExp(r'sin⁻¹\(([^)]+)\)'), (match) {
      double value = double.parse(match.group(1)!);
      return (asin(value) * 180 / pi).toString();
    });
    input = input.replaceAllMapped(RegExp(r'cos⁻¹\(([^)]+)\)'), (match) {
      double value = double.parse(match.group(1)!);
      return (acos(value) * 180 / pi).toString();
    });
    input = input.replaceAllMapped(RegExp(r'tan⁻¹\(([^)]+)\)'), (match) {
      double value = double.parse(match.group(1)!);
      return (atan(value) * 180 / pi).toString();
    });

    input = input.replaceAllMapped(
        RegExp(r'√(\d+(\.\d+)?)'), (match) => 'sqrt(${match.group(1)})');

    input = input.replaceAll('π', '3.141592653589793');
    input = input.replaceAll('e', '2.718281828459045');
    input = input.replaceAllMapped(
        RegExp(r'10\^\(([^)]+)\)'), (match) => 'pow(10, ${match.group(1)})');
    input = input.replaceAllMapped(RegExp(r'e\^'), (match) => 'exp(');

    return input;
  }
}
