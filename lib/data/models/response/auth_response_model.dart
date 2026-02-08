import 'dart:convert';

class AuthResponseModel {
  final User? user;
  final String? token;
  final bool is2faRequired;
  final int? userId;
  final String? message;
  final String? email;

  AuthResponseModel({
    this.user,
    this.token,
    this.is2faRequired = false,
    this.userId,
    this.message,
    this.email,
  });

  // Fungsi dari String JSON ke Object
  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  // Fungsi dari Object ke String JSON
  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"],
        // Perbaikan logika: Cek field 'message' ATAU '2fa_required'
        is2faRequired:
            json["message"] == "2FA_REQUIRED" ||
            (json["2fa_required"] ?? false),
        userId: json["user_id"],
        message: json["message"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
    "user": user?.toMap(),
    "token": token,
    "2fa_required": is2faRequired,
    "user_id": userId,
    "message": message,
    "email": email,
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? roles;

  User({this.id, this.name, this.email, this.roles});

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    roles: json["roles"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "roles": roles,
  };
}
