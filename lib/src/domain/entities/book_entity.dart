import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  final bool isFavorite;
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    required this.isFavorite,
  });
  @override
  List<Object> get props => [id];

  @override
  bool? get stringify => true;
}
