import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // final Color color;
  const CustomButton({
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
          backgroundColor: const Color.fromARGB(255, 128, 136, 214),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          // shape:
          ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 228, 228, 228),
          fontSize: 14,
        ),
      ),
    );
  }
}
