import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/snack_bar_notifier.dart';
import 'package:flutter/material.dart';

class SnackBarComponent extends StatelessWidget {
  SnackBarComponent({super.key});
  final SnackBarNotifier snackBarNotifier = SnackBarNotifier();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showSnackbar(
    BuildContext context,
    String message,
  ) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackbarWithCloseAction(
      BuildContext context, String message, VoidCallback action) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((_) => action());
  }

  void hideSnackBar(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
