import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/preferences_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:escribo_flutter_anderson/src/data/models/epub_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHandler {
  static late SharedPreferences _instance;
  init(SharedPreferences? instance) async {
    if (instance != null) {
      _instance = instance;
    }
    _instance = await SharedPreferences.getInstance();
  }

  Future<Either<String, ErrorInfo>> updateFavorite(BookModel book) async {
    try {
      String? jsonFavoriteBooksOld =
          _instance.getString(PreferencesConstants.favoriteBooksKey);
      List<BookModel> bookList = [];
      bool addFavorite = true;
      if (jsonFavoriteBooksOld == null) {
        bookList.add(book.copyWith(isFavorite: true));
      } else {
        bookList = jsonDecode(jsonFavoriteBooksOld)
            .map<BookModel>((book) => BookModel.fromJson(book))
            .toList();
        if (bookList.contains(book)) {
          addFavorite = false;
          bookList.remove(book);
        } else {
          bookList.add(book.copyWith(isFavorite: true));
        }
      }
      String jsonFavoriteBooksNew = jsonEncode(bookList);
      await _instance.setString(
          PreferencesConstants.favoriteBooksKey, jsonFavoriteBooksNew);
      if (addFavorite) {
        return Left("${book.title} ${Strings.msgAddFavorite}");
      } else {
        return Left("${book.title} ${Strings.msgRemoveFavorite}");
      }
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.preferencesError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Either<List<BookModel>, ErrorInfo> getFavoritesBooks() {
    try {
      String? jsonFavoriteBooksOld =
          _instance.getString(PreferencesConstants.favoriteBooksKey);
      List<BookModel> bookList = [];
      if (jsonFavoriteBooksOld != null) {
        bookList = jsonDecode(jsonFavoriteBooksOld)
            .map<BookModel>((book) => BookModel.fromJson(book))
            .toList();
      }
      return Left(bookList);
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.preferencesError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, ErrorInfo>> saveLastLocationEpub(
      EpubInfoModel epubInfoModel) async {
    try {
      await _instance.setString(
          "${PreferencesConstants.lastLocationEpubKey}_${epubInfoModel.bookId}",
          jsonEncode(epubInfoModel.toJson()));
      return const Left(true);
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: '', stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Either<Map<String, dynamic>, ErrorInfo> getLastLocationEpub(int bookId) {
    try {
      String? epubInfoJson = _instance
          .getString("${PreferencesConstants.lastLocationEpubKey}_$bookId");

      if (epubInfoJson == null) {
        return const Left({});
      } else {
        final String decoded = jsonDecode(epubInfoJson);
        final EpubInfoModel epubInfo = EpubInfoModel.fromJson(decoded);
        return Left(epubInfo.lastLocation);
      }
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: '', stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, ErrorInfo>> saveDownloadedBook(BookModel book) async {
    try {
      String? jsonDownloadBooksOld =
          _instance.getString(PreferencesConstants.downloadBookListKey);
      List<BookModel> bookList = [];
      if (jsonDownloadBooksOld != null) {
        bookList = jsonDecode(jsonDownloadBooksOld)
            .map<BookModel>((book) => BookModel.fromJson(book))
            .toList();
      }
      bookList.add(book);
      String jsonDownloadBooksNew = jsonEncode(bookList);
      await _instance.setString(
          PreferencesConstants.downloadBookListKey, jsonDownloadBooksNew);

      return const Left(true);
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: '', stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Either<List<BookModel>, ErrorInfo> getDownloadedBooks() {
    try {
      String? jsonDownloadBooksOld =
          _instance.getString(PreferencesConstants.downloadBookListKey);
      List<BookModel> bookList = [];
      if (jsonDownloadBooksOld != null) {
        bookList = jsonDecode(jsonDownloadBooksOld)
            .map<BookModel>((book) => BookModel.fromJson(book))
            .toList();
      }
      return Left(bookList);
    } catch (e, stacktrace) {
      return Right(ErrorInfo(
          message: Strings.preferencesError,
          stackTrace: StackTrace.fromString("$e\n$stacktrace")));
    }
  }
}
