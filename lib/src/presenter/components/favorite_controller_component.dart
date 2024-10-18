import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/update_favorite_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/show_snack_bar.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_bloc.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_event.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/favorite_button_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteControllerComponent extends StatelessWidget {
  final FavoriteButtonNotifier favoriteButtonNotifier;
  final Book book;
  final bool hasSelectedFavoriteButton;
  final Widget child;
  const FavoriteControllerComponent(
      {super.key,
      required this.book,
      required this.child,
      required this.favoriteButtonNotifier,
      this.hasSelectedFavoriteButton = false});

  @override
  Widget build(BuildContext context) {
    BooksBloc booksBloc = Provider.of<BooksBloc>(context);
    UpdateFavoriteUseCase updateFavoriteUseCase =
        Provider.of<UpdateFavoriteUseCase>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: favoriteButtonNotifier.state,
      builder: (BuildContext context, _, __) {
        return GestureDetector(
          onTap: () async {
            favoriteButtonNotifier
                .updateFavorite(!favoriteButtonNotifier.state.value);

            if (hasSelectedFavoriteButton) {
              booksBloc.add(LoadBooksFavoritesEvent());
            }
            var result = await updateFavoriteUseCase.execute(book);

            if (!context.mounted) return;

            showSnackbar(context,
                result is DataSuccess ? result.data! : result.error!.message);
          },
          child: child,
        );
      },
    );
  }
}
