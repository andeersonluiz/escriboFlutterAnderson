import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/entities/book_entity.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/download_book_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/favorite_controller_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/opacity_controller_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/components/show_snack_bar.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/favorite_button_notifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final bool hasSelectedFavoriteButton;
  final FavoriteButtonNotifier favoriteButtonNotifier =
      FavoriteButtonNotifier();
  BookTile(
      {super.key, required this.book, required this.hasSelectedFavoriteButton});

  @override
  Widget build(BuildContext context) {
    favoriteButtonNotifier.updateFavorite(book.isFavorite);

    return OpacityControllerComponent(
      child: Column(
        children: [
          Expanded(
              flex: 8,
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    _buildBookCoverImage(context),
                    _buildFavoriteButton(context),
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                book.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              )))
        ],
      ),
    );
  }

  Widget _buildBookCoverImage(
    BuildContext context,
  ) {
    DownloadBookUseCase downloadBookUseCase =
        Provider.of<DownloadBookUseCase>(context);
    return Positioned.fill(
      child: GestureDetector(
        onTap: () async {
          showSnackbar(context, 'Fazendo download de ${book.title}');
          final result = await downloadBookUseCase.execute(book);
          if (!context.mounted) return;

          showSnackbar(context,
              result is DataSuccess ? result.data! : result.error!.message);
        },
        child: Image.network(
          book.coverUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(
    BuildContext context,
  ) {
    return OpacityControllerComponent(
        enableOpacity: false,
        child: FavoriteControllerComponent(
          book: book,
          favoriteButtonNotifier: favoriteButtonNotifier,
          hasSelectedFavoriteButton: hasSelectedFavoriteButton,
          child: Stack(
            children: [
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  FontAwesomeIcons.solidBookmark,
                  size: 38,
                  color: Colors.white,
                ),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: favoriteButtonNotifier.state,
                  builder: (BuildContext context, dynamic value, _) {
                    return Positioned(
                      right: 3,
                      top: 0,
                      child: value
                          ? Icon(
                              FontAwesomeIcons.solidBookmark,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : Icon(
                              FontAwesomeIcons.bookmark,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    );
                  }),
            ],
          ),
        ));
  }
}
