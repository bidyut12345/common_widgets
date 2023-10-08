import 'package:flutter/material.dart';

class CustomHomeItemButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // final Color color;
  const CustomHomeItemButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.indigo[900],
          elevation: 20,
          backgroundColor: const Color.fromARGB(255, 99, 103, 154),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
          // shape:
          ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 228, 228, 228),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
