import 'package:flutter/foundation.dart';

class DownloadNotifier {
  final _state = ValueNotifier<String>('');

  ValueListenable<String> get state => _state;

  String get value => _state.value;

  void setPathBook(String newValue) {
    _state.value = newValue;
  }
}
