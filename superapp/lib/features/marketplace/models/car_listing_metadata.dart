import 'dart:convert';
import 'package:equatable/equatable.dart';

class CarListingMetadata extends Equatable {
  final List<CarMake> makes;
  final List<MetadataItem> emirates;
  final List<MetadataItem> bodyTypes;
  final List<MetadataItem> regionalSpecs;
  final List<MetadataItem> transmissions;
  final List<MetadataItem> chargingTypes;
  final List<MetadataItem> exteriorColors;
  final List<MetadataItem> interiorColors;
  final List<MetadataItem> warrantyOptions;
  final List<MetadataItem> doorTypes;
  final List<MetadataItem> engineCylinders;
  final List<MetadataItem> seatingCapacities;
  final List<MetadataItem> horsepowers;
  final List<MetadataItem> steeringSides;
  final List<MetadataItem> engineCapacities;
  final List<MetadataItem> safetyFeatures;
  final List<MetadataItem> techFeatures;
  final List<MetadataItem> comfortFeatures;
  final List<MetadataItem> exteriorFeatures;
  final List<PlanModel> plans;

  CarListingMetadata({
    required this.makes,
    required this.emirates,
    required this.bodyTypes,
    required this.regionalSpecs,
    required this.transmissions,
    required this.chargingTypes,
    required this.exteriorColors,
    required this.interiorColors,
    required this.warrantyOptions,
    required this.doorTypes,
    required this.engineCylinders,
    required this.seatingCapacities,
    required this.horsepowers,
    required this.steeringSides,
    required this.engineCapacities,
    required this.safetyFeatures,
    required this.techFeatures,
    required this.comfortFeatures,
    required this.exteriorFeatures,
    required this.plans,
  });

  @override
  List<Object?> get props => [
        makes,
        emirates,
        bodyTypes,
        regionalSpecs,
        transmissions,
        chargingTypes,
        exteriorColors,
        interiorColors,
        plans
      ];


  factory CarListingMetadata.fromJson(Map<String, dynamic> json) {
    return CarListingMetadata(
      makes: (json["makes"] as List? ?? []).map((x) => CarMake.fromJson(x)).toList(),
      emirates: (json["emirates"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      bodyTypes: (json["body_types"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      regionalSpecs: (json["regional_specs"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      transmissions: (json["transmissions"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      chargingTypes: (json["charging_types"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      exteriorColors: (json["exterior_colors"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      interiorColors: (json["interior_colors"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      warrantyOptions: (json["warranty_options"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      doorTypes: (json["door_types"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      engineCylinders: (json["engine_cylinders"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      seatingCapacities: (json["seating_capacities"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      horsepowers: (json["horsepowers"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      steeringSides: (json["steering_sides"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      engineCapacities: (json["engine_capacities"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      safetyFeatures: (json["safety_features"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      techFeatures: (json["tech_features"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      comfortFeatures: (json["comfort_features"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      exteriorFeatures: (json["exterior_features"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      plans: (json["plans"] as List? ?? []).map((x) => PlanModel.fromJson(x)).toList(),
    );
  }

  // Fallback for UI compatibility with older code
  List<MetadataItem> get colors => exteriorColors;
}

class MetadataItem extends Equatable {
  final int id;
  final String name;
  final bool? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? carModelId;

  MetadataItem({
    required this.id,
    required this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.carModelId,
  });

  factory MetadataItem.fromJson(Map<String, dynamic> json) => MetadataItem(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
        status: json["status"],
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
        carModelId: json["car_model_id"],
      );

  @override
  List<Object?> get props => [id];
}

class CarMake extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final bool status;
  final List<CarModel> models;

  CarMake({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.status,
    required this.models,
  });

  factory CarMake.fromJson(Map<String, dynamic> json) => CarMake(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
        imageUrl: json["image_url"],
        status: json["status"] ?? true,
        models: (json["models"] as List? ?? []).map((x) => CarModel.fromJson(x)).toList(),
      );

  @override
  List<Object?> get props => [id];
}

class CarModel extends Equatable {
  final int id;
  final int carMakeId;
  final String name;
  final bool status;
  final List<MetadataItem> trims;

  CarModel({
    required this.id,
    required this.carMakeId,
    required this.name,
    required this.status,
    required this.trims,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"] ?? 0,
        carMakeId: json["car_make_id"] ?? 0,
        name: json["name"] ?? "Unknown",
        status: json["status"] ?? true,
        trims: (json["trims"] as List? ?? []).map((x) => MetadataItem.fromJson(x)).toList(),
      );

  @override
  List<Object?> get props => [id];
}

class PlanModel {
  final int id;
  final String name;
  final int price;
  final int durationDays;
  final int featuredDays;
  final int refreshCount;
  final bool isRecommended;
  final List<String> benefits;
  final bool status;

  PlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.featuredDays,
    required this.refreshCount,
    required this.isRecommended,
    required this.benefits,
    required this.status,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Plan",
        price: json["price"] ?? 0,
        durationDays: json["duration_days"] ?? 0,
        featuredDays: json["featured_days"] ?? 0,
        refreshCount: json["refresh_count"] ?? 0,
        isRecommended: json["is_recommended"] ?? false,
        benefits: List<String>.from(json["benefits"]?.map((x) => x.toString()) ?? []),
        status: json["status"] ?? true,
      );

  // UI mapping helpers
  String get title => name;
  String get badgeText => isRecommended ? "Recommended" : "";
  List<String> get included => [
        'Ad is live for $durationDays days',
        if (featuredDays > 0) 'Featured for $featuredDays days',
        if (refreshCount > 0) '$refreshCount x Refresh included',
      ];
  String get buttonText => "Select $name";
}
