// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class EpubInfoModel {
  final int bookId;
  final bool fileExists;
  final String message;
  final String path;
  final Map<String, dynamic> lastLocation;

  EpubInfoModel({
    required this.bookId,
    required this.fileExists,
    required this.message,
    this.path = '',
    this.lastLocation = const {},
  });

  EpubInfoModel copyWith({
    int? bookId,
    bool? fileExists,
    String? message,
    String? path,
    Map<String, dynamic>? lastLocation,
  }) {
    return EpubInfoModel(
      bookId: bookId ?? this.bookId,
      fileExists: fileExists ?? this.fileExists,
      message: message ?? this.message,
      path: path ?? this.path,
      lastLocation: lastLocation ?? this.lastLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookId': bookId,
      'fileExists': fileExists,
      'message': message,
      'path': path,
      'lastLocation': lastLocation,
    };
  }

  factory EpubInfoModel.fromMap(Map<String, dynamic> map) {
    return EpubInfoModel(
        bookId: map['bookId'] as int,
        fileExists: map['fileExists'] as bool,
        message: map['message'] as String,
        path: map['path'] as String,
        lastLocation: Map<String, dynamic>.from(
          (map['lastLocation'] as Map<String, dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory EpubInfoModel.fromJson(String source) =>
      EpubInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EpubInfoModel(bookId: $bookId, fileExists: $fileExists, message: $message, path: $path, lastLocation: $lastLocation)';
  }

  @override
  bool operator ==(covariant EpubInfoModel other) {
    if (identical(this, other)) return true;

    return other.bookId == bookId &&
        other.fileExists == fileExists &&
        other.message == message &&
        other.path == path &&
        mapEquals(other.lastLocation, lastLocation);
  }

  @override
  int get hashCode {
    return bookId.hashCode ^
        fileExists.hashCode ^
        message.hashCode ^
        path.hashCode ^
        lastLocation.hashCode;
  }
}
