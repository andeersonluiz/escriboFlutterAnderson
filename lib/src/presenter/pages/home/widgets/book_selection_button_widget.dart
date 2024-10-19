import 'package:flutter/material.dart';

class BookSelectionButtonWidget extends StatelessWidget {
  final String name;
  final Function() onPressed;
  final bool isSelected;
  final EdgeInsets padding;
  const BookSelectionButtonWidget({
    super.key,
    required this.name,
    required this.onPressed,
    required this.isSelected,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface),
          child: Text(name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.black))),
    );
  }
}
