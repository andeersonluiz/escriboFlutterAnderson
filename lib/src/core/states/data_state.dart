import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:flutter/foundation.dart';

abstract class DataState<T> {
  const DataState({this.data, this.error});

  final T? data;
  final ErrorInfo? error;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataStream<T> extends DataState<T> {
  const DataStream(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(ErrorInfo error) : super(error: error) {
    // Enviar erro para o sistema de monitoramento de falhas para análise posterior
    if (kDebugMode) {
      print("errorName:${error.message}");
      print("stacktrace:${error.stackTrace}");
    }
  }
}
