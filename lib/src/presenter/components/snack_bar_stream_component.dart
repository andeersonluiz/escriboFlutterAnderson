import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/snack_bar_notifier.dart';
import 'package:flutter/material.dart';

class SnackBarStreamComponent extends StatelessWidget {
  final SnackBarNotifier snackBarNotifier = SnackBarNotifier();

  SnackBarStreamComponent({super.key});

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      duration: const Duration(days: 365),
      content: ValueListenableBuilder<String>(
        valueListenable: snackBarNotifier.state,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Text(value);
        },
      ),
    );
  }

  void updateString(String newString) {
    snackBarNotifier.updateString(newString);
  }

  void hideSnackBar(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
