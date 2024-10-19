// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EpubInfo extends Equatable {
  final int bookId;
  final bool fileExists;
  final String message;
  final String path;
  final Map<String, dynamic> lastLocation;

  const EpubInfo({
    required this.bookId,
    required this.fileExists,
    required this.message,
    this.path = '',
    this.lastLocation = const {},
  });

  @override
  List<Object?> get props => [bookId];

  @override
  bool? get stringify => true;

  EpubInfo copyWith({
    int? bookId,
    bool? fileExists,
    String? message,
    String? path,
    Map<String, dynamic>? lastLocation,
  }) {
    return EpubInfo(
      bookId: bookId ?? this.bookId,
      fileExists: fileExists ?? this.fileExists,
      message: message ?? this.message,
      path: path ?? this.path,
      lastLocation: lastLocation ?? this.lastLocation,
    );
  }
}
