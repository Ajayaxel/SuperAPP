class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String roleName;
  final String? verification;
  final String? createdAt;
  final List<Role>? roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.roleName,
    this.verification,
    this.createdAt,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      roleName: json['role_name'] ?? '',
      verification: json['verification'],
      createdAt: json['created_at'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((i) => Role.fromJson(i)).toList()
          : null,
    );
  }
}

class Role {
  final int id;
  final String name;
  final String guardName;
  final Pivot? pivot;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      guardName: json['guard_name'],
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }
}

class Pivot {
  final String modelType;
  final int modelId;
  final int roleId;

  Pivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelType: json['model_type'],
      modelId: json['model_id'] is int ? json['model_id'] : int.parse(json['model_id'].toString()),
      roleId: json['role_id'] is int ? json['role_id'] : int.parse(json['role_id'].toString()),
    );
  }
}

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}
