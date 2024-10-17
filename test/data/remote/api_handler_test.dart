import 'package:dio/dio.dart';
import 'package:escribo_flutter_anderson/src/core/constants/path_constants.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/exceptions/no_connection_exception.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/local/preferences_handler.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/remote/api_handler.dart';
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
  group('APIHandler tests', () {
    late MockDio mockDio;
    late APIHandler apiHandler;
    late PreferencesHandler preferencesHandlerMock;

    setUp(() async {
      mockDio = MockDio();
      apiHandler = APIHandler(dio: mockDio);
      SharedPreferences.setMockInitialValues({});
      SharedPreferences instanceMock = await SharedPreferences.getInstance();
      preferencesHandlerMock = PreferencesHandler();
      await preferencesHandlerMock.init(instanceMock);
    });

    group('getBooks() test', () {
      test('should return a list of books', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: mockJson,
              statusCode: 200,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));

        final result = await apiHandler.getBooks();
        result.fold((books) {
          expect(books.length, 2);
          expect(books[0].title, 'The Bible of Nature');
          expect(books[1].title, "Kazan");
        }, (errorInfo) => fail('Should not return an error'));
      });

      test('should return an error 404', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: {'error': 'Not Found'},
              statusCode: 404,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));

        final result = await apiHandler.getBooks();
        result.fold((books) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.resourceNotFound));
      });

      test('should return a statusCodeError', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: {'error': 'Internal Server Error'},
              statusCode: 500,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));

        final result = await apiHandler.getBooks();
        result.fold((books) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.unknownError));
      });

      test('should return a connection error', () async {
        when(() => mockDio.get(apiUrl))
            .thenThrow(NoConnectionException(message: Strings.noConnection));

        final result = await apiHandler.getBooks();
        result.fold((books) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.noConnection));
      });

      test('should return an unknown error', () async {
        when(() => mockDio.get(apiUrl)).thenThrow(DioException(
          requestOptions:
              RequestOptions(path: 'https://escribo.com/books.json'),
        ));

        final result = await apiHandler.getBooks();
        result.fold((books) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.databaseError));
      });
    });

    group('getBook(id) tests', () {
      test('should return a book', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: mockJson,
              statusCode: 200,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));

        final result = await apiHandler.getBook(1);
        result.fold((book) {
          expect(book.title, 'The Bible of Nature');
        }, (errorInfo) => fail('Should not return an error'));
      });
      test('should return an error book not found', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: mockJson,
              statusCode: 200,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));

        final result = await apiHandler.getBook(58);
        result.fold((book) {
          fail('Should not return an success');
        }, (errorInfo) => expect(errorInfo.message, Strings.bookNotFound));
      });
    });
    group('downloadBook(book) tests', () {
      test('should return a message with success download', () async {
        when(() => mockDio.get(apiUrl)).thenAnswer((_) async => Response(
              data: mockJson,
              statusCode: 200,
              requestOptions:
                  RequestOptions(path: "https://escribo.com/books.json"),
            ));
        final book = await apiHandler.getBook(1);
        String savePath =
            '${PathConstants.pathDownloadAndroid}/${book.left.title}.epub';
        when(() => mockDio.download(book.left.downloadUrl, savePath))
            .thenAnswer((_) async => Response(
                  data: [],
                  statusCode: 200,
                  requestOptions: RequestOptions(path: book.left.downloadUrl),
                ));

        final result = await apiHandler.downloadBook(book.left);
        result.fold(
            (stringSuccess) => expect(stringSuccess,
                "${Strings.downloadSuccess} ${PathConstants.pathDownloadAndroid}"),
            (errorInfo) => fail('Should not return an error'));
      });
      test('should return a message with an error download', () async {
        final book = booksMock[1];
        String savePath =
            '${PathConstants.pathDownloadAndroid}/${book.title}.epub';
        when(() => mockDio.download(book.downloadUrl, savePath))
            .thenAnswer((_) async => Response(
                  data: [],
                  statusCode: 404,
                  requestOptions: RequestOptions(path: book.downloadUrl),
                ));

        final result = await apiHandler.downloadBook(book);
        result.fold((stringSuccess) => fail('Should not return an success'),
            (errorInfo) => expect(errorInfo.message, Strings.downloadError));
      });

      test('should return a message with the error download url invalid',
          () async {
        final book = booksMock[1];
        String savePath =
            '${PathConstants.pathDownloadAndroid}/${book.title}.epub';
        when(() => mockDio.download('book.downloadUrl', savePath))
            .thenAnswer((_) async => Response(
                  data: [],
                  statusCode: 404,
                  requestOptions: RequestOptions(path: book.downloadUrl),
                ));

        final result = await apiHandler.downloadBook(book);
        result.fold((stringSuccess) => fail('Should not return an success'),
            (errorInfo) => expect(errorInfo.message, Strings.unknownError));
      });
    });
  });
}
