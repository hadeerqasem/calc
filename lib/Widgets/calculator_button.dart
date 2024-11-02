import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const CalculatorButton({
    super.key,
    required this.symbol,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: buttonBackgroundColor(symbol),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: TextStyle(
            color: buttonTextColor(symbol),
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Color buttonBackgroundColor(String symbol) {
    if (['%', '/', '*', '-', '+', 'C', 'Del'].contains(symbol))
      return isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    if (symbol == '=') return Color.fromARGB(255, 251, 107, 35);
    return isDarkMode ? Colors.grey.shade900 : Colors.white;
  }

  Color buttonTextColor(String symbol) {
    if (['C', 'Del' '%', '/', '*', '-', '+'].contains(symbol)) {
      return isDarkMode ? Colors.white : Colors.black;
    }
    if (symbol == '=') return Colors.white;
    return isDarkMode ? Colors.white : Colors.black;
  }
}

