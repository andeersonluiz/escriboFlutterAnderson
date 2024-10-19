import 'package:dio/dio.dart';
import 'package:escribo_flutter_anderson/src/core/constants/preferences_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/local/preferences_handler.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importando o mockito

class MockDio extends Mock implements Dio {}

const apiUrl = "https://escribo.com/books.json";

const mockJson = [
  {
    "id": 1,
    "title": "The Bible of Nature",
    "author": "Oswald, Felix L.",
    "cover_url":
        "https://www.gutenberg.org/cache/epub/72134/pg72134.cover.medium.jpg",
    "download_url": "https://www.gutenberg.org/ebooks/72134.epub3.images"
  },
  {
    "id": 2,
    "title": "Kazan",
    "author": "Curwood, James Oliver",
    "cover_url":
        "https://www.gutenberg.org/cache/epub/72127/pg72127.cover.medium.jpg",
    "download_url": "https://www.gutenberg.org/ebooks/72127.epub.images"
  }
];

List<BookModel> booksMock = [
  BookModel(
    id: 1,
    title: "The Bible of Nature",
    author: "Oswald, Felix L.",
    coverUrl:
        "https://www.gutenberg.org/cache/epub/72134/pg72134.cover.medium.jpg",
    downloadUrl: "https://www.gutenberg.org/ebooks/72134.epub3.images",
  ),
  BookModel(
    id: 2,
    title: "Kazan",
    author: "Curwood, James Oliver",
    coverUrl:
        "https://www.gutenberg.org/cache/epub/72127/pg72127.cover.medium.jpg",
    downloadUrl: "https://www.gutenberg.org/ebooks/72127.epub.images",
  ),
];

void main() {
  group('PrefencesHandler tests', () {
    late PreferencesHandler preferencesHandlerMock;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences instanceMock = await SharedPreferences.getInstance();
      preferencesHandlerMock = PreferencesHandler();
      await preferencesHandlerMock.init(instanceMock);
    });

    group('updateFavorite(book) tests', () {
      test('should return success add favorite', () async {
        final book = booksMock[1];

        final result = await preferencesHandlerMock.updateFavorite(book);
        result.fold((message) {
          expect(message, "${book.title} ${Strings.msgAddFavorite}");
        }, (errorInfo) => fail('Should not return an error'));
      });

      test('should return success remove favorite', () async {
        final book = booksMock[1];
        await preferencesHandlerMock.updateFavorite(book);
        final result = await preferencesHandlerMock.updateFavorite(book);
        result.fold((message) {
          expect(message, "${book.title} ${Strings.msgRemoveFavorite}");
        }, (errorInfo) => fail('Should not return an error'));
      });

      test('should return error when update favorite', () async {
        final book = booksMock[1];

        SharedPreferences.setMockInitialValues({
          PreferencesConstants.favoriteBooksKey: 'Teste',
        });
        SharedPreferences instanceMock = await SharedPreferences.getInstance();
        await preferencesHandlerMock.init(instanceMock);

        final result = await preferencesHandlerMock.updateFavorite(book);

        result.fold((message) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.preferencesError));
      });
    });
    group('getFavorites() tests', () {
      test('should return list favorites after insert', () async {
        await preferencesHandlerMock.updateFavorite(booksMock[1]);
        await preferencesHandlerMock.updateFavorite(booksMock[0]);

        final favoriteBooks = preferencesHandlerMock.getFavoritesBooks();
        favoriteBooks.fold((booksResult) {
          expect(booksResult.length, 2);
          expect(booksResult[0], booksMock[1]);
          expect(booksResult[1], booksMock[0]);
        }, (errorInfo) => fail('Should not return an error'));
      });

      test('should return an empty list of favorites after being removed',
          () async {
        await preferencesHandlerMock.updateFavorite(booksMock[1]);
        await preferencesHandlerMock.updateFavorite(booksMock[0]);

        await preferencesHandlerMock.updateFavorite(booksMock[1]);
        await preferencesHandlerMock.updateFavorite(booksMock[0]);

        final favoriteBooks = preferencesHandlerMock.getFavoritesBooks();
        favoriteBooks.fold((booksResult) {
          expect(booksResult.length, 0);
        }, (errorInfo) => fail('Should not return an error'));
      });
      test('should return an error when getting a favorite list', () async {
        SharedPreferences.setMockInitialValues({
          PreferencesConstants.favoriteBooksKey: 'Teste',
        });
        SharedPreferences instanceMock = await SharedPreferences.getInstance();
        await preferencesHandlerMock.init(instanceMock);

        final result = preferencesHandlerMock.getFavoritesBooks();

        result.fold((message) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.preferencesError));
      });
    });
  });
}
