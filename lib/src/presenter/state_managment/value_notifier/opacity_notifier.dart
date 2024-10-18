import 'package:flutter/foundation.dart';

class OpacityNotifier {
  final _state = ValueNotifier<double>(1);

  ValueListenable<double> get state => _state;

  double get value => _state.value;

  updateOpacity(double value) {
    _state.value = value;
  }
}
