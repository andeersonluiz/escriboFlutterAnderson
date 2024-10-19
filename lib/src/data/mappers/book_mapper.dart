import 'package:escribo_flutter_anderson/src/data/mappers/base_mapper.dart';
import 'package:escribo_flutter_anderson/src/data/models/book_model.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';

class BookMapper extends Mapper<Book, BookModel> {
  @override
  BookModel entityToModel(Book entity) {
    return BookModel(
        id: entity.id,
        title: entity.title,
        author: entity.author,
        coverUrl: entity.coverUrl,
        downloadUrl: entity.downloadUrl,
        isFavorite: entity.isFavorite,
        isDownloaded: entity.isDownloaded);
  }

  @override
  Book modelToEntity(BookModel model) {
    return Book(
        id: model.id,
        title: model.title,
        author: model.author,
        coverUrl: model.coverUrl,
        downloadUrl: model.downloadUrl,
        isFavorite: model.isFavorite,
        isDownloaded: model.isDownloaded);
  }
}
