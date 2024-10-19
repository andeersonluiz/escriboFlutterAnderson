import 'package:bloc/bloc.dart';
import 'package:escribo_flutter_anderson/src/core/constants/strings.dart';
import 'package:escribo_flutter_anderson/src/core/states/data_state.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/domain/usecases/get_favorite_books_use_case.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_event.dart';
import 'package:escribo_flutter_anderson/src/presenter/state_managment/bloc/books/books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final GetBooksUseCase _getBooksUseCase;
  final GetFavoritesBooksUseCase _getFavoritesBooksUseCase;

  BooksBloc(this._getBooksUseCase, this._getFavoritesBooksUseCase)
      : super(const LoadingBooks()) {
    on<LoadBooksEvent>(_loadBooks);
    on<LoadBooksFavoritesEvent>(_loadBooksFavorites);
  }

  Future<void> _loadBooks(
      LoadBooksEvent event, Emitter<BooksState> emit) async {
    emit(const LoadingBooks());

    final result = await _getBooksUseCase.execute();
    if (result is DataSuccess) {
      emit(LoadedBooks(books: result.data!));
    } else {
      emit(ErrorBooks(msg: result.error!.message));
    }
  }

  Future<void> _loadBooksFavorites(
      LoadBooksFavoritesEvent event, Emitter<BooksState> emit) async {
    emit(const LoadingBooks());

    final result = _getFavoritesBooksUseCase.execute();
    if (result is DataSuccess) {
      if (result.data!.isEmpty) {
        return emit(const EmptyBooks(msg: Strings.emptyFavorites));
      }
      emit(LoadedBooks(books: result.data!));
    } else {
      emit(ErrorBooks(msg: result.error!.message));
    }
  }
}
