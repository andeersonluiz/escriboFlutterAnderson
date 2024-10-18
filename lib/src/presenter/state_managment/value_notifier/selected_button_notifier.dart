import 'package:flutter/foundation.dart';

class SelectedButtonNotifier {
  final _state = ValueNotifier(true);

  ValueListenable<bool> get state => _state;

  bool get value => _state.value;

  update(bool newValue) {
    _state.value = newValue;
  }
}
