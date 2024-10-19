import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';

class SaveLastLocationEpubUseCase {
  final BookRepository bookRepository;
  SaveLastLocationEpubUseCase(this.bookRepository);

  Future<DataState<bool>> execute(EpubInfo epubInfo) async {
    return await bookRepository.saveLastLocationEpub(epubInfo);
  }
}
