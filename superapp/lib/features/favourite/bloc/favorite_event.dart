import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {
  final int page;
  const FetchFavoritesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final int carListingId;
  const ToggleFavoriteEvent({required this.carListingId});

  @override
  List<Object?> get props => [carListingId];
}
