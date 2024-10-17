import 'package:escribo_flutter_anderson/src/core/models/error_info.dart';
import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/local/preferences_handler.dart';
import 'package:escribo_flutter_anderson/src/data/datasource/remote/api_handler.dart';
import 'package:escribo_flutter_anderson/src/data/mappers/book_mapper.dart';
import 'package:escribo_flutter_anderson/src/data/repositories/book_repository_impl.dart';
import 'package:escribo_flutter_anderson/src/domain/repositories/book_repository.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/download_book_use_case.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_book_use_case.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/update_favorite_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderInjection extends StatelessWidget {
  const ProviderInjection({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<APIHandler>(
          create: (_) => APIHandler(),
        ),
        Provider<PreferencesHandler>(
          create: (_) => PreferencesHandler(),
        ),
        Provider<BookMapper>(
          create: (_) => BookMapper(),
        ),
        Provider<BookRepository>(
          create: (context) {
            return BookRepositoryImpl(
                apiHandler: context.read<APIHandler>(),
                preferencesHandler: context.read<PreferencesHandler>(),
                bookMapper: context.read<BookMapper>());
          },
        ),
        Provider<GetBooksUseCase>(
            create: (context) =>
                GetBooksUseCase(context.read<BookRepositoryImpl>())),
        Provider<GetBookUseCase>(
            create: (context) =>
                GetBookUseCase(context.read<BookRepositoryImpl>())),
        Provider<UpdateFavoriteUseCase>(
            create: (context) =>
                UpdateFavoriteUseCase(context.read<BookRepositoryImpl>())),
        Provider<DownloadBookUseCase>(
            create: (context) =>
                DownloadBookUseCase(context.read<BookRepositoryImpl>())),
      ],
      child: Builder(builder: (context) {
        return FutureBuilder(
            future: _initializeDependencies(context.read<PreferencesHandler>()),
            builder: (ctx, snp) {
              if (snp.connectionState == ConnectionState.done) {
                return child;
              } else if (snp.hasError) {
                return Center(child: Text('Erro ao inicializar: ${snp.error}'));
              }
              return const Center(child: CircularProgressIndicator());
            });
      }),
    );
  }
}

Future<void> _initializeDependencies(
  PreferencesHandler preferencesHandler,
) async {
  try {
    await preferencesHandler.init(null);
  } catch (e, stacktrace) {
    DataFailed(ErrorInfo(
        message: 'Erro ao inicializar PreferencesHandler',
        stackTrace: StackTrace.fromString("$e\n$stacktrace")));
  }
}
