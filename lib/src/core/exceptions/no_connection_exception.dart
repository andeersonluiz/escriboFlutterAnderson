class NoConnectionException implements Exception {
  NoConnectionException(
      {required this.message, this.stackTrace = StackTrace.empty});
  final String message;
  final StackTrace stackTrace;

  @override
  String toString() => message;
}
