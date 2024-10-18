import 'package:flutter/material.dart';

class ErrorGridBooks extends StatelessWidget {
  final String msgError;
  const ErrorGridBooks({super.key, required this.msgError});

  @override
  Widget build(BuildContext context) {
    return Text(
      msgError,
      style: const TextStyle(
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}
