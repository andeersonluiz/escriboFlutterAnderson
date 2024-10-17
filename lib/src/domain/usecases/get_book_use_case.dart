import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class GetBookUseCase {
  final BookRepository bookRepository;
  GetBookUseCase(this.bookRepository);

  Future<DataState<Book>> execute(int id) async {
    return await bookRepository.getBook(id);
  }
}
