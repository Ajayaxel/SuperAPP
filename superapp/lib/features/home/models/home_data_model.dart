// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

HomeDataModel homeDataModelFromJson(String str) => HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
    bool success;
    Data data;

    HomeDataModel({
        required this.success,
        required this.data,
    });

    factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        success: json["success"] ?? false,
        data: Data.fromJson(json["data"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    List<FreshRecommendation> freshRecommendations;
    List<FreshRecommendation> popularListings;

    Data({
        required this.freshRecommendations,
        required this.popularListings,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        freshRecommendations: json["fresh_recommendations"] != null ? List<FreshRecommendation>.from(json["fresh_recommendations"].map((x) => FreshRecommendation.fromJson(x))) : [],
        popularListings: json["popular_listings"] != null ? List<FreshRecommendation>.from(json["popular_listings"].map((x) => FreshRecommendation.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "fresh_recommendations": List<dynamic>.from(freshRecommendations.map((x) => x.toJson())),
        "popular_listings": List<dynamic>.from(popularListings.map((x) => x.toJson())),
    };
}

class FreshRecommendation {
    int id;
    int userId;
    int emirateId;
    int carMakeId;
    int carModelId;
    int carTrimId;
    int regionalSpecId;
    int year;
    int kilometers;
    int bodyTypeId;
    bool isInsured;
    String price;
    String phoneNumber;
    String title;
    String description;
    int exteriorColorId;
    int interiorColorId;
    int warrantyOptionId;
    int chargingTypeId;
    int doorTypeId;
    int engineCylinderId;
    int transmissionId;
    int seatingCapacityId;
    int horsepowerId;
    int steeringSideId;
    int engineCapacityId;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic location;
    dynamic buildingStreet;
    String latitude;
    String longitude;
    String conditionType;
    bool isVerified;
    bool inspectionVerified;
    int planId;
    dynamic locationName;
    String sellerType;
    List<HomeCarImage> images;
    HomeMake make;
    HomeEmirate model;
    HomeEmirate emirate;
    HomeUser user;
    HomePlan plan;
    List<Feature> safetyFeatures;
    List<Feature> techFeatures;
    List<Feature> comfortFeatures;
    List<Feature> exteriorFeatures;
    bool isFavorite;

    FreshRecommendation({
        required this.id,
        required this.userId,
        required this.emirateId,
        required this.carMakeId,
        required this.carModelId,
        required this.carTrimId,
        required this.regionalSpecId,
        required this.year,
        required this.kilometers,
        required this.bodyTypeId,
        required this.isInsured,
        required this.price,
        required this.phoneNumber,
        required this.title,
        required this.description,
        required this.exteriorColorId,
        required this.interiorColorId,
        required this.warrantyOptionId,
        required this.chargingTypeId,
        required this.doorTypeId,
        required this.engineCylinderId,
        required this.transmissionId,
        required this.seatingCapacityId,
        required this.horsepowerId,
        required this.steeringSideId,
        required this.engineCapacityId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.location,
        required this.buildingStreet,
        required this.latitude,
        required this.longitude,
        required this.conditionType,
        required this.isVerified,
        required this.inspectionVerified,
        required this.planId,
        required this.locationName,
        required this.sellerType,
        required this.images,
        required this.make,
        required this.model,
        required this.emirate,
        required this.user,
        required this.plan,
        required this.safetyFeatures,
        required this.techFeatures,
        required this.comfortFeatures,
        required this.exteriorFeatures,
        this.isFavorite = false,
    });

    factory FreshRecommendation.fromJson(Map<String, dynamic> json) => FreshRecommendation(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        emirateId: json["emirate_id"] ?? 0,
        carMakeId: json["car_make_id"] ?? 0,
        carModelId: json["car_model_id"] ?? 0,
        carTrimId: json["car_trim_id"] ?? 0,
        regionalSpecId: json["regional_spec_id"] ?? 0,
        year: json["year"] ?? 0,
        kilometers: json["kilometers"] ?? 0,
        bodyTypeId: json["body_type_id"] ?? 0,
        isInsured: json["is_insured"] ?? false,
        price: json["price"]?.toString() ?? "0",
        phoneNumber: json["phone_number"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        exteriorColorId: json["exterior_color_id"] ?? 0,
        interiorColorId: json["interior_color_id"] ?? 0,
        warrantyOptionId: json["warranty_option_id"] ?? 0,
        chargingTypeId: json["charging_type_id"] ?? 0,
        doorTypeId: json["door_type_id"] ?? 0,
        engineCylinderId: json["engine_cylinder_id"] ?? 0,
        transmissionId: json["transmission_id"] ?? 0,
        seatingCapacityId: json["seating_capacity_id"] ?? 0,
        horsepowerId: json["horsepower_id"] ?? 0,
        steeringSideId: json["steering_side_id"] ?? 0,
        engineCapacityId: json["engine_capacity_id"] ?? 0,
        status: json["status"] ?? "",
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        location: json["location"],
        buildingStreet: json["building_street"],
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        conditionType: json["condition_type"] ?? "",
        isVerified: json["is_verified"] ?? false,
        inspectionVerified: json["inspection_verified"] ?? false,
        planId: json["plan_id"] ?? 0,
        locationName: json["location_name"],
        sellerType: json["seller_type"] ?? "",
        images: json["images"] != null ? List<HomeCarImage>.from(json["images"].map((x) => HomeCarImage.fromJson(x))) : [],
        make: HomeMake.fromJson(json["make"] ?? {}),
        model: HomeEmirate.fromJson(json["model"] ?? {}),
        emirate: HomeEmirate.fromJson(json["emirate"] ?? {}),
        user: HomeUser.fromJson(json["user"] ?? {}),
        plan: HomePlan.fromJson(json["plan"] ?? {}),
        safetyFeatures: json["safety_features"] != null ? List<Feature>.from(json["safety_features"].map((x) => Feature.fromJson(x))) : [],
        techFeatures: json["tech_features"] != null ? List<Feature>.from(json["tech_features"].map((x) => Feature.fromJson(x))) : [],
        comfortFeatures: json["comfort_features"] != null ? List<Feature>.from(json["comfort_features"].map((x) => Feature.fromJson(x))) : [],
        exteriorFeatures: json["exterior_features"] != null ? List<Feature>.from(json["exterior_features"].map((x) => Feature.fromJson(x))) : [],
        isFavorite: json["is_favorite"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "emirate_id": emirateId,
        "car_make_id": carMakeId,
        "car_model_id": carModelId,
        "car_trim_id": carTrimId,
        "regional_spec_id": regionalSpecId,
        "year": year,
        "kilometers": kilometers,
        "body_type_id": bodyTypeId,
        "is_insured": isInsured,
        "price": price,
        "phone_number": phoneNumber,
        "title": title,
        "description": description,
        "exterior_color_id": exteriorColorId,
        "interior_color_id": interiorColorId,
        "warranty_option_id": warrantyOptionId,
        "charging_type_id": chargingTypeId,
        "door_type_id": doorTypeId,
        "engine_cylinder_id": engineCylinderId,
        "transmission_id": transmissionId,
        "seating_capacity_id": seatingCapacityId,
        "horsepower_id": horsepowerId,
        "steering_side_id": steeringSideId,
        "engine_capacity_id": engineCapacityId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "location": location,
        "building_street": buildingStreet,
        "latitude": latitude,
        "longitude": longitude,
        "condition_type": conditionType,
        "is_verified": isVerified,
        "inspection_verified": inspectionVerified,
        "plan_id": planId,
        "location_name": locationName,
        "seller_type": sellerType,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "make": make.toJson(),
        "model": model.toJson(),
        "emirate": emirate.toJson(),
        "user": user.toJson(),
        "plan": plan.toJson(),
        "safety_features": List<dynamic>.from(safetyFeatures.map((x) => x.toJson())),
        "tech_features": List<dynamic>.from(techFeatures.map((x) => x.toJson())),
        "comfort_features": List<dynamic>.from(comfortFeatures.map((x) => x.toJson())),
        "exterior_features": List<dynamic>.from(exteriorFeatures.map((x) => x.toJson())),
        "is_favorite": isFavorite,
    };
}

class HomeEmirate {
    int id;
    String name;
    bool status;
    DateTime createdAt;
    DateTime updatedAt;
    int? carMakeId;

    HomeEmirate({
        required this.id,
        required this.name,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        this.carMakeId,
    });

    factory HomeEmirate.fromJson(Map<String, dynamic> json) => HomeEmirate(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        status: json["status"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        carMakeId: json["car_make_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "car_make_id": carMakeId,
    };
}

class HomeCarImage {
    int id;
    int carListingId;
    String image;
    bool isMain;
    DateTime createdAt;
    DateTime updatedAt;
    String imageUrl;

    HomeCarImage({
        required this.id,
        required this.carListingId,
        required this.image,
        required this.isMain,
        required this.createdAt,
        required this.updatedAt,
        required this.imageUrl,
    });

    factory HomeCarImage.fromJson(Map<String, dynamic> json) => HomeCarImage(
        id: json["id"] ?? 0,
        carListingId: json["car_listing_id"] ?? 0,
        image: json["image"] ?? "",
        isMain: json["is_main"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        imageUrl: json["image_url"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "car_listing_id": carListingId,
        "image": image,
        "is_main": isMain,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image_url": imageUrl,
    };
}

class HomeMake {
    int id;
    String name;
    dynamic image;
    bool status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic imageUrl;

    HomeMake({
        required this.id,
        required this.name,
        required this.image,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.imageUrl,
    });

    factory HomeMake.fromJson(Map<String, dynamic> json) => HomeMake(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        image: json["image"],
        status: json["status"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image_url": imageUrl,
    };
}

class HomePlan {
    int id;
    String name;
    int price;
    int durationDays;
    int featuredDays;
    int refreshCount;
    bool isRecommended;
    List<String> benefits;
    bool status;
    DateTime createdAt;
    DateTime updatedAt;

    HomePlan({
        required this.id,
        required this.name,
        required this.price,
        required this.durationDays,
        required this.featuredDays,
        required this.refreshCount,
        required this.isRecommended,
        required this.benefits,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory HomePlan.fromJson(Map<String, dynamic> json) => HomePlan(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        price: json["price"] ?? 0,
        durationDays: json["duration_days"] ?? 0,
        featuredDays: json["featured_days"] ?? 0,
        refreshCount: json["refresh_count"] ?? 0,
        isRecommended: json["is_recommended"] ?? false,
        benefits: json["benefits"] != null ? List<String>.from(json["benefits"].map((x) => x)) : [],
        status: json["status"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "duration_days": durationDays,
        "featured_days": featuredDays,
        "refresh_count": refreshCount,
        "is_recommended": isRecommended,
        "benefits": List<dynamic>.from(benefits.map((x) => x)),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class HomeUser {
    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic profileImage;
    bool status;
    String verification;
    dynamic dealerId;
    bool isDealerAdmin;
    dynamic profileImageUrl;
    String roleName;
    List<Role> roles;

    HomeUser({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.profileImage,
        required this.status,
        required this.verification,
        required this.dealerId,
        required this.isDealerAdmin,
        required this.profileImageUrl,
        required this.roleName,
        required this.roles,
    });

    factory HomeUser.fromJson(Map<String, dynamic> json) => HomeUser(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        profileImage: json["profile_image"],
        status: json["status"] ?? false,
        verification: json["verification"] ?? "",
        dealerId: json["dealer_id"],
        isDealerAdmin: json["is_dealer_admin"] ?? false,
        profileImageUrl: json["profile_image_url"],
        roleName: json["role_name"] ?? "",
        roles: json["roles"] != null ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "profile_image": profileImage,
        "status": status,
        "verification": verification,
        "dealer_id": dealerId,
        "is_dealer_admin": isDealerAdmin,
        "profile_image_url": profileImageUrl,
        "role_name": roleName,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    };
}

class Role {
    int id;
    String name;
    String guardName;
    DateTime createdAt;
    DateTime updatedAt;
    Pivot pivot;

    Role({
        required this.id,
        required this.name,
        required this.guardName,
        required this.createdAt,
        required this.updatedAt,
        required this.pivot,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        guardName: json["guard_name"] ?? "",
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        pivot: Pivot.fromJson(json["pivot"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
    };
}

class Pivot {
    String modelType;
    int modelId;
    int roleId;

    Pivot({
        required this.modelType,
        required this.modelId,
        required this.roleId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelType: json["model_type"] ?? "",
        modelId: json["model_id"] ?? 0,
        roleId: json["role_id"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
    };
}

class Feature {
    int id;
    String name;
    bool status;
    DateTime createdAt;
    DateTime updatedAt;

    Feature({
        required this.id,
        required this.name,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        status: json["status"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
