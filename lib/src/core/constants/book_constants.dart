import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';

class BookConstants {
  static final BookModel defaultBookModel =
      BookModel(id: -1, title: '', author: '', coverUrl: '', downloadUrl: '');

  static const Book defaultBook = Book(
      id: -1,
      title: '',
      author: '',
      coverUrl: '',
      downloadUrl: '',
      isFavorite: false,
      isDownloaded: false);
}
