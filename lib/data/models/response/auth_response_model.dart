import 'dart:convert';

class AuthResponseModel {
  final User? user;
  final String? token;
  final bool is2faRequired;
  final int? userId;
  final String? message;
  final String? email;
  final String? twoFactorToken;

  AuthResponseModel({
    this.user,
    this.token,
    this.is2faRequired = false,
    this.userId,
    this.message,
    this.email,
    this.twoFactorToken,
  });

  // =========================
  // API RESPONSE (Map)
  // =========================
  factory AuthResponseModel.fromMap(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: json['user'] != null ? User.fromMap(json['user']) : null,
      token: json['token']?.toString(),
      is2faRequired:
          json['2fa_required'] == true || json['message'] == '2FA_REQUIRED',
      userId: json['user_id'],
      message: json['message'],
      email: json['email'],
      twoFactorToken: json['two_factor_token']?.toString(),
    );
  }

  // =========================
  // LOCAL STORAGE (String)
  // =========================
  factory AuthResponseModel.fromJson(String source) {
    return AuthResponseModel.fromMap(jsonDecode(source));
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'token': token,
      '2fa_required': is2faRequired,
      'user_id': userId,
      'message': message,
      'email': email,
    };
  }

  // =========================
  // COPY WITH
  // =========================
  AuthResponseModel copyWith({
    User? user,
    String? token,
    bool? is2faRequired,
    int? userId,
    String? message,
    String? email,
    String? twoFactorToken,
  }) {
    return AuthResponseModel(
      user: user ?? this.user,
      token: token ?? this.token,
      is2faRequired: is2faRequired ?? this.is2faRequired,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      email: email ?? this.email,
      twoFactorToken: twoFactorToken ?? this.twoFactorToken,
    );
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? roles;
  final bool? twoFactorEnabled;

  User({this.id, this.name, this.email, this.roles, this.twoFactorEnabled});

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roles: json['roles'],
      twoFactorEnabled:
          json['two_factor_enabled'] == true || json['two_factor_enabled'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'two_factor_enabled': twoFactorEnabled,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? roles,
    bool? twoFactorEnabled,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }
}
