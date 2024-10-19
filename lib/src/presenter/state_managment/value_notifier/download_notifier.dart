import 'package:flutter/foundation.dart';

class DownloadNotifier {
  final _state = ValueNotifier<bool>(false);

  ValueListenable<bool> get state => _state;

  bool get value => _state.value;

  void setIsDownloading(bool newValue) {
    _state.value = newValue;
  }

  void setIsDownloaded(bool newValue) {
    _state.value = newValue;
  }
}
