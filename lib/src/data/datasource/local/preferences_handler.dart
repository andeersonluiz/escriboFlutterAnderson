import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:escribo_flutter_anderson/src/core/constants/preferences_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
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
        bookList.add(book);
      } else {
        bookList = jsonDecode(jsonFavoriteBooksOld)
            .map<BookModel>((book) => BookModel.fromJson(book))
            .toList();
        if (bookList.contains(book)) {
          addFavorite = false;
          bookList.remove(book);
        } else {
          bookList.add(book);
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

  Future<Either<List<BookModel>, ErrorInfo>> getFavoritesBooks() async {
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
}
