import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/data/mappers/epub_info_mapper.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/local/preferences_handler.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/remote/api_handler.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/remote/download_service.dart';
import 'package:escribo_flutter_anderson/src/data/mappers/book_mapper.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class BookRepositoryImpl extends BookRepository {
  final APIHandler apiHandler;
  final BookMapper bookMapper;
  final EpubInfoMapper epubInfoMapper;
  final PreferencesHandler preferencesHandler;
  final DownloadService downloadService;

  BookRepositoryImpl(
      {required this.apiHandler,
      required this.bookMapper,
      required this.epubInfoMapper,
      required this.preferencesHandler,
      required this.downloadService});

  @override
  Future<DataState<List<Book>>> getBooks() async {
    final books = await apiHandler.getBooks();
    final favoriteBooks = preferencesHandler.getFavoritesBooks();
    final downloadedBooks = preferencesHandler.getDownloadedBooks();

    if (books.isRight) {
      return DataFailed(books.right);
    }
    if (favoriteBooks.isRight) {
      return DataFailed(favoriteBooks.right);
    }
    if (downloadedBooks.isRight) {
      return DataFailed(downloadedBooks.right);
    }
    final booksResult = books.left;
    final favoriteBooksResult = favoriteBooks.left;
    final downloadedBookResults = downloadedBooks.left;

    final updatedBooksModel = booksResult.map((book) {
      return book.copyWith(
          isFavorite: favoriteBooksResult.contains(book),
          isDownloaded: downloadedBookResults.contains(book));
    }).toList();
    return DataSuccess(updatedBooksModel
        .map((bookModel) => bookMapper.modelToEntity(bookModel))
        .toList());
  }

  @override
  Stream<DataState<String>> downloadBook(Book book) async* {
    try {
      await Permission.notification.request();
      downloadService.downloadBook(bookMapper.entityToModel(book));

      await for (int progress in downloadService.downloadProgressStream) {
        String progressText =
            'Progresso do download: ${progress > 100 ? 100 : progress}%';
        if (progress == 101) {
          await preferencesHandler
              .saveDownloadedBook(bookMapper.entityToModel(book));
          yield DataSuccess('${book.title} foi baixado com sucesso!!');
        } else if (progress == -1) {
          yield DataFailed(ErrorInfo(
              message:
                  'Ocorreu um erro ao fazer o download, verifique sua conexão.'));
        }
        yield DataStream(progressText);
      }
    } catch (e, stacktrace) {
      yield DataFailed(ErrorInfo(
          message: Strings.unknownError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  @override
  Future<DataState<EpubInfo>> checkBookDownloaded(Book book) async {
    try {
      final result = await downloadService
          .checkBookDownloaded(bookMapper.entityToModel(book));

      return result.fold((epubInfoModel) {
        final resultLastLocation =
            preferencesHandler.getLastLocationEpub(epubInfoModel.bookId);

        return resultLastLocation.fold(
            (lastLocation) => DataSuccess(epubInfoMapper.modelToEntity(
                epubInfoModel.copyWith(lastLocation: lastLocation))),
            (errorInfo) => DataFailed(errorInfo));
      }, (errorInfo) => DataFailed(errorInfo));
    } catch (e, stacktrace) {
      return DataFailed(ErrorInfo(
          message: Strings.unknownError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  @override
  Future<DataState<String>> updateFavorite(Book book) async {
    final result =
        preferencesHandler.updateFavorite(bookMapper.entityToModel(book));
    return result.fold((resultString) => DataSuccess(resultString),
        (errorInfo) => DataFailed(errorInfo));
  }

  @override
  DataState<List<Book>> getFavoritesBooks() {
    final result = preferencesHandler.getFavoritesBooks();
    return result.fold(
        (books) => DataSuccess(books
            .map((booksModel) => bookMapper.modelToEntity(booksModel))
            .toList()),
        (errorInfo) => DataFailed(errorInfo));
  }

  @override
  Future<DataState<bool>> saveLastLocationEpub(EpubInfo epubInfo) async {
    final result = await preferencesHandler
        .saveLastLocationEpub(epubInfoMapper.entityToModel(epubInfo));
    return result.fold((isSuccess) => DataSuccess(isSuccess),
        (errorInfo) => DataFailed(errorInfo));
  }

  @override
  DataState<List<Book>> getDownloadedBooks() {
    final result = preferencesHandler.getDownloadedBooks();
    return result.fold(
        (books) => DataSuccess(books
            .map((booksModel) => bookMapper.modelToEntity(booksModel))
            .toList()),
        (errorInfo) => DataFailed(errorInfo));
  }
}
