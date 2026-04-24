import 'package:equatable/equatable.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';

abstract class SellCarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSellCarMetadata extends SellCarEvent {}

class UpdateSellCarForm extends SellCarEvent {
  final Map<String, dynamic> data;
  UpdateSellCarForm(this.data);
  @override
  List<Object?> get props => [data];
}

class SubmitSellCarListing extends SellCarEvent {
  final List<String> imagePaths;
  SubmitSellCarListing({required this.imagePaths});
  @override
  List<Object?> get props => [imagePaths];
}

abstract class SellCarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SellCarInitial extends SellCarState {}

class SellCarMetadataLoading extends SellCarState {}

class SellCarMetadataLoaded extends SellCarState {
  final CarListingMetadata metadata;
  SellCarMetadataLoaded(this.metadata);
  @override
  List<Object?> get props => [metadata];
}

class SellCarSubmitting extends SellCarState {}

class SellCarSuccess extends SellCarState {}

class SellCarFailure extends SellCarState {
  final String error;
  SellCarFailure(this.error);
  @override
  List<Object?> get props => [error];
}
