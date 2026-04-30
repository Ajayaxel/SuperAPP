import 'package:equatable/equatable.dart';
import '../models/favorite_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {
  final FavoriteData? previousData;
  const FavoriteLoading({this.previousData});

  @override
  List<Object?> get props => [previousData];
}

class FavoriteLoaded extends FavoriteState {
  final FavoriteData favoriteData;
  const FavoriteLoaded({required this.favoriteData});

  @override
  List<Object?> get props => [favoriteData];
}

class ToggleFavoriteSuccess extends FavoriteState {
  final String message;
  final int carListingId;
  const ToggleFavoriteSuccess({required this.message, required this.carListingId});

  @override
  List<Object?> get props => [message, carListingId];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError({required this.message});

  @override
  List<Object?> get props => [message];
}
