import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/book_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/exceptions/no_connection_exception.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/core/network/connection_verifyer.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:dio/dio.dart';

class APIHandler {
  final apiUrl = "https://escribo.com/books.json";
  final Dio dio;

  APIHandler({Dio? dio}) : dio = dio ?? Dio();

  Future<Either<List<BookModel>, ErrorInfo>> getBooks() async {
    return await _fetchData(
        fromJson: (books) => books
            .map<BookModel>((jsonItem) => BookModel.fromMap(jsonItem))
            .toSet()
            .toList());
  }

  Future<Either<T, ErrorInfo>> _fetchData<T>(
      {required T Function(dynamic) fromJson}) async {
    try {
      await ConnectionVerifyer.verify();
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        return Left(fromJson(response.data));
      } else if (response.statusCode == 404) {
        return Right(ErrorInfo(message: Strings.resourceNotFound));
      } else {
        return Right(ErrorInfo(message: Strings.unknownError));
      }
    } on NoConnectionException catch (e) {
      return Right(ErrorInfo(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.databaseError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }
}
