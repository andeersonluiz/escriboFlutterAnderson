import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';

abstract class BookRepository {
  Future<DataState<List<Book>>> getBooks();
  Future<DataState<bool>> saveLastLocationEpub(EpubInfo epubInfo);
  Future<DataState<EpubInfo>> checkBookDownloaded(Book book);
  Stream<DataState<String>> downloadBook(Book book);
  Future<DataState<String>> updateFavorite(Book book);
  DataState<List<Book>> getFavoritesBooks();
  DataState<List<Book>> getDownloadedBooks();
}
