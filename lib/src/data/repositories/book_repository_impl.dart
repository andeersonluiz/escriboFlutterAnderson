import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/local/preferences_handler.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/remote/api_handler.dart';
import 'package:escribo_flutter_anderson/src/data/mappers/book_mapper.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class BookRepositoryImpl extends BookRepository {
  final APIHandler apiHandler;
  final BookMapper bookMapper;
  final PreferencesHandler preferencesHandler;

  BookRepositoryImpl(
      {required this.apiHandler,
      required this.bookMapper,
      required this.preferencesHandler});

  @override
  Future<DataState<List<Book>>> getBooks() async {
    final result = await apiHandler.getBooks();
    return result.fold(
        (booksModel) => DataSuccess(booksModel
            .map((bookModel) => bookMapper.modelToEntity(bookModel))
            .toList()),
        (errorInfo) => DataFailed(errorInfo));
  }

  @override
  Future<DataState<Book>> getBook(int id) async {
    final result = await apiHandler.getBook(id);
    return result.fold(
        (booksModel) => DataSuccess(bookMapper.modelToEntity(booksModel)),
        (errorInfo) => DataFailed(errorInfo));
  }

  @override
  Future<DataState<String>> downloadBook(Book book) async {
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        final result =
            await apiHandler.downloadBook(bookMapper.entityToModel(book));
        return result.fold((successString) => DataSuccess(successString),
            (errorInfo) => DataFailed(errorInfo));
      } else {
        return DataFailed(ErrorInfo(message: Strings.insufficientPermissions));
      }
    } catch (e, stacktrace) {
      return DataFailed(ErrorInfo(
          message: Strings.unknownError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  @override
  Future<DataState<String>> updateFavorite(Book book) async {
    final result =
        preferencesHandler.updateFavorite(BookMapper().entityToModel(book));
    return result.fold((resultString) => DataSuccess(resultString),
        (errorInfo) => DataFailed(errorInfo));
  }
}
