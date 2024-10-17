import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class DownloadBookUseCase {
  final BookRepository bookRepository;
  DownloadBookUseCase(this.bookRepository);

  Future<DataState<String>> execute(Book book) async {
    return await bookRepository.downloadBook(book);
  }
}
