import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class CheckBookDownloadedUseCase {
  final BookRepository bookRepository;
  CheckBookDownloadedUseCase(this.bookRepository);

  Future<DataState<EpubInfo>> execute(Book book) async {
    return await bookRepository.checkBookDownloaded(book);
  }
}
