import 'package:flutter/foundation.dart';

class SnackBarNotifier {
  final _state = ValueNotifier<String>('');

  ValueListenable<String> get state => _state;

  String get value => _state.value;

  void updateString(String newString) {
    _state.value = newString;
  }
}
