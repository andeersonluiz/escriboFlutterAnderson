import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  final bool isFavorite;
  final bool isDownloaded;
  const Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.coverUrl,
      required this.downloadUrl,
      required this.isFavorite,
      required this.isDownloaded});
  @override
  List<Object> get props => [id];

  @override
  bool? get stringify => true;
}
