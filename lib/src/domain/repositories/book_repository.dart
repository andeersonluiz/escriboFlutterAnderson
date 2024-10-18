import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';

abstract class BookRepository {
  Future<DataState<List<Book>>> getBooks();
  Future<DataState<Book>> getBook(int id);
  Future<DataState<String>> downloadBook(Book book);
  Future<DataState<String>> updateFavorite(Book book);
  Future<DataState<List<Book>>> getFavoritesBooks();
}
