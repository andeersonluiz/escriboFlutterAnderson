import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class GetFavoritesBooksUseCase {
  final BookRepository bookRepository;
  GetFavoritesBooksUseCase(this.bookRepository);

  Future<DataState<List<Book>>> execute() async {
    return await bookRepository.getFavoritesBooks();
  }
}
