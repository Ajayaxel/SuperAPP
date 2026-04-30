import 'package:equatable/equatable.dart';
import '../../auth/models/user_model.dart';
import '../../marketplace/models/car_listing_metadata.dart';

class CarListingModel extends Equatable {
  final int id;
  final String title;
  final String price;
  final bool isVerified;
  final String? conditionType;
  final int? kilometers;
  final String? description;
  final int? year;
  final CarMake? make;
  final CarModelItem? model;
  final EmirateItem? emirate;
  final List<CarImage> images;
  final UserModel? user;
  final PlanModel? plan;

  const CarListingModel({
    required this.id,
    required this.title,
    required this.price,
    required this.isVerified,
    this.conditionType,
    this.kilometers,
    this.description,
    this.year,
    this.make,
    this.model,
    this.emirate,
    this.images = const [],
    this.user,
    this.plan,
  });

  factory CarListingModel.fromJson(Map<String, dynamic> json) {
    return CarListingModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '0',
      isVerified: json['is_verified'] ?? false,
      conditionType: json['condition_type'],
      kilometers: json['kilometers'],
      description: json['description'],
      year: json['year'],
      make: json['make'] != null ? CarMake.fromJson(json['make']) : null,
      model: json['model'] != null ? CarModelItem.fromJson(json['model']) : null,
      emirate: json['emirate'] != null ? EmirateItem.fromJson(json['emirate']) : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => CarImage.fromJson(e))
              .toList() ??
          [],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      plan: json['plan'] != null ? PlanModel.fromJson(json['plan']) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        isVerified,
        conditionType,
        kilometers,
        description,
        year,
        make,
        model,
        emirate,
        images,
        user,
        plan,
      ];
}

class CarModelItem extends Equatable {
  final int id;
  final String name;

  const CarModelItem({required this.id, required this.name});

  factory CarModelItem.fromJson(Map<String, dynamic> json) {
    return CarModelItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class EmirateItem extends Equatable {
  final int id;
  final String name;

  const EmirateItem({required this.id, required this.name});

  factory EmirateItem.fromJson(Map<String, dynamic> json) {
    return EmirateItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class CarImage extends Equatable {
  final int id;
  final String? imageUrl;
  final bool isMain;

  const CarImage({
    required this.id,
    this.imageUrl,
    this.isMain = false,
  });

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'],
      isMain: json['is_main'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, isMain];
}
