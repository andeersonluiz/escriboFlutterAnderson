class ErrorInfo {
  final String message;
  final StackTrace stackTrace;

  ErrorInfo({required this.message, this.stackTrace = StackTrace.empty});

  @override
  String toString() => "$message: $stackTrace";
}
