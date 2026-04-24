import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/features/marketplace/repository/marketplace_repository.dart';
import 'sell_car_bloc_states.dart';

class SellCarBloc extends Bloc<SellCarEvent, SellCarState> {
  final MarketplaceRepository _repository;
  Map<String, dynamic> _formData = {};

  SellCarBloc(this._repository) : super(SellCarInitial()) {
    on<LoadSellCarMetadata>(_onLoadMetadata);
    on<UpdateSellCarForm>(_onUpdateForm);
    on<SubmitSellCarListing>(_onSubmitListing);
  }

  Map<String, dynamic> get formData => _formData;

  Future<void> _onLoadMetadata(LoadSellCarMetadata event, Emitter<SellCarState> emit) async {
    emit(SellCarMetadataLoading());
    try {
      final metadata = await _repository.getCarListingMetadata();
      emit(SellCarMetadataLoaded(metadata));
    } catch (e) {
      emit(SellCarFailure(e.toString()));
    }
  }

  void _onUpdateForm(UpdateSellCarForm event, Emitter<SellCarState> emit) {
    _formData.addAll(event.data);
  }

  Future<void> _onSubmitListing(SubmitSellCarListing event, Emitter<SellCarState> emit) async {
    emit(SellCarSubmitting());
    try {
      await _repository.storeUsedCarListing(
        listingData: _formData,
        imagePaths: event.imagePaths,
      );
      emit(SellCarSuccess());
      _formData = {}; // Clear after success
    } catch (e) {
      emit(SellCarFailure(e.toString()));
    }
  }
}
