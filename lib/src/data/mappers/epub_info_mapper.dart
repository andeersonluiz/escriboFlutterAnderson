import 'package:escribo_flutter_anderson/src/data/mappers/base_mapper.dart';
import 'package:escribo_flutter_anderson/src/data/models/epub_info_model.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';

class EpubInfoMapper extends Mapper<EpubInfo, EpubInfoModel> {
  @override
  EpubInfoModel entityToModel(EpubInfo entity) {
    return EpubInfoModel(
        bookId: entity.bookId,
        fileExists: entity.fileExists,
        message: entity.message,
        lastLocation: entity.lastLocation,
        path: entity.path);
  }

  @override
  EpubInfo modelToEntity(EpubInfoModel model) {
    return EpubInfo(
        bookId: model.bookId,
        fileExists: model.fileExists,
        message: model.message,
        lastLocation: model.lastLocation,
        path: model.path);
  }
}
