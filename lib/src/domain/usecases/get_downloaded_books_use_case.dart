import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class GetDownloadedBooksUseCase {
  final BookRepository bookRepository;
  GetDownloadedBooksUseCase(this.bookRepository);

  DataState<List<Book>> execute() {
    return bookRepository.getDownloadedBooks();
  }
}
