import 'dart:convert';

import 'package:escribo_flutter_anderson/src/domain/entities/epub_info_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/save_last_location_epub_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class VocysEpubController {
  final BuildContext context;
  final EpubInfo epubInfo;
  late final SaveLastLocationEpubUseCase saveLastLocationEpubUseCase;
  VocysEpubController({required this.context, required this.epubInfo}) {
    saveLastLocationEpubUseCase = context.read<SaveLastLocationEpubUseCase>();
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).colorScheme.primary,
      scrollDirection: EpubScrollDirection.VERTICAL,
      allowSharing: true,
      enableTts: true,
      nightMode: false,
    );
    VocsyEpub.locatorStream.listen((locator) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      saveLastLocationEpubUseCase
          .execute(epubInfo.copyWith(lastLocation: jsonDecode(locator)));
    });
  }

  void open(String path, Map<String, dynamic> lastLocation) {
    VocsyEpub.open(
      path,
      lastLocation: EpubLocator.fromJson(lastLocation),
    );
  }
}
