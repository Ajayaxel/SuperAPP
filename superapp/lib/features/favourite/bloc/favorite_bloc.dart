import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/favorite_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteBloc({FavoriteRepository? repository})
      : _repository = repository ?? FavoriteRepository(),
        super(FavoriteInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      emit(FavoriteLoading(previousData: currentState.favoriteData));
    } else {
      emit(const FavoriteLoading());
    }
    try {
      final response = await _repository.getFavorites(page: event.page);
      emit(FavoriteLoaded(favoriteData: response.data));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final response = await _repository.toggleFavorite(event.carListingId);
      if (response['success'] == true) {
        emit(ToggleFavoriteSuccess(
          message: response['message'] ?? 'Action successful',
          carListingId: event.carListingId,
        ));
      } else {
        emit(FavoriteError(message: response['message'] ?? 'Failed to toggle favorite'));
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }
}
