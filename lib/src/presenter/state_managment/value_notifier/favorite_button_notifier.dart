import 'package:flutter/foundation.dart';

class FavoriteButtonNotifier {
  final _state = ValueNotifier<bool>(true);

  ValueListenable<bool> get state => _state;

  bool get value => _state.value;

  void updateFavorite(bool newValue) {
    _state.value = newValue;
  }
}
