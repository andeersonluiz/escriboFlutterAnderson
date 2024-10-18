import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/opacity_notifier.dart';
import 'package:flutter/material.dart';

class OpacityControllerComponent extends StatelessWidget {
  final Widget child;
  final OpacityNotifier opacityNotifier = OpacityNotifier();
  final bool enableOpacity;
  OpacityControllerComponent(
      {super.key, required this.child, this.enableOpacity = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          opacityNotifier.updateOpacity(enableOpacity ? 0.7 : 1);
          Future.delayed(const Duration(milliseconds: 200),
              () => opacityNotifier.updateOpacity(1));
        },
        child: ValueListenableBuilder<double>(
            valueListenable: opacityNotifier.state,
            builder: (BuildContext context, dynamic value, _) {
              return Opacity(
                opacity: value,
                child: child,
              );
            }));
  }
}
