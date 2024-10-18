// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';

class BooksState extends Equatable {
  final List<Book> books;
  final String msg;
  const BooksState({this.books = const [], this.msg = ''});

  @override
  List<Object> get props => [books];
}

class LoadingBooks extends BooksState {
  const LoadingBooks();
}

class LoadedBooks extends BooksState {
  const LoadedBooks({required super.books});
}

class EmptyBooks extends BooksState {
  const EmptyBooks({required super.msg});
}

class ErrorBooks extends BooksState {
  const ErrorBooks({required super.msg});
}
