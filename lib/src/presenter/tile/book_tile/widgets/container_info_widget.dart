import 'package:flutter/material.dart';

class ContainerInfoWidget extends StatelessWidget {
  final String text;
  const ContainerInfoWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.grey)),
      constraints: const BoxConstraints(minWidth: 50),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
