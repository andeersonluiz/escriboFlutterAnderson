import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:flutter/foundation.dart';

class DownloadedBooksNotifier {
  final ValueNotifier<List<Book>> _queueBooks = ValueNotifier<List<Book>>([]);

  ValueListenable<List<Book>> get queueBooks => _queueBooks;

  final ValueNotifier<Book?> _bookDownloading = ValueNotifier<Book?>(null);

  ValueListenable<Book?> get bookDownloading => _bookDownloading;

  final ValueNotifier<List<Book>> _downloadedBooks =
      ValueNotifier<List<Book>>([]);

  ValueListenable<List<Book>> get downloadedBooks => _downloadedBooks;

  void addBookQueue(Book book) {
    _queueBooks.value = [..._queueBooks.value, book];
  }

  void removeBookQueue(Book book) {
    final tempList = List<Book>.from(_queueBooks.value);
    tempList.remove(book);
    _queueBooks.value = tempList;
  }

  void setBookDownloading(Book? book) {
    _bookDownloading.value = (book);
  }

  void addDownloadedBooks(Book book) {
    _downloadedBooks.value = [..._downloadedBooks.value, book];
  }

  void loadDownloadedBooks(List<Book> books) {
    _downloadedBooks.value = books;
  }
}
