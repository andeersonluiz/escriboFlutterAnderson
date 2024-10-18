import 'package:escribo_flutter_anderson/src/presenter/components/custom_app_bar_component.dart';
import 'package:escribo_flutter_anderson/src/presenter/pages/widgets/book_selection_button_widget.dart';
import 'package:escribo_flutter_anderson/src/presenter/pages/widgets/error_grid_books_widget.dart';
import 'package:escribo_flutter_anderson/src/presenter/pages/widgets/grid_books_widget.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_bloc.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_event.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/value_notifier/selected_button_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../state_managment/bloc/books/books_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BooksBloc booksBloc;
  late SelectedButtonNotifier selectedButtonNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    booksBloc = Provider.of<BooksBloc>(context);
    selectedButtonNotifier = Provider.of<SelectedButtonNotifier>(context);
    booksBloc.add(LoadBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarComponent(),
        body: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: selectedButtonNotifier.state,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BookSelectionButtonWidget(
                      name: "Livros",
                      onPressed: () {
                        booksBloc.add(LoadBooksEvent());
                        selectedButtonNotifier.update(true);
                      },
                      isSelected: selectedButtonNotifier.state.value,
                    ),
                    BookSelectionButtonWidget(
                      name: "favoritos",
                      onPressed: () {
                        booksBloc.add(LoadBooksFavoritesEvent());
                        selectedButtonNotifier.update(false);
                      },
                      isSelected: !selectedButtonNotifier.state.value,
                    )
                  ],
                );
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: BlocBuilder<BooksBloc, BooksState>(
                    builder: (_, BooksState state) {
                      if (state is LoadedBooks) {
                        return GridBooksWidget(
                            listBooks: state.books,
                            hasSelectedFavoriteButton:
                                !selectedButtonNotifier.state.value);
                      } else if (state is ErrorBooks || state is EmptyBooks) {
                        return ErrorGridBooks(msgError: state.msg);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
