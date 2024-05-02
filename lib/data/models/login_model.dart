class LoginResponseModel {
  final String token;
  final int id;
  final String refreshToken;
  final String email;
  final String userName;
  final List<String> roles;
  final String type;
  final String name;

  LoginResponseModel({
    required this.token,
    required this.id,
    required this.email,
    required this.userName,
    required this.roles,
    required this.type,
    required this.refreshToken,
    required this.name,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["accessToken"] ?? "",
      id: json["id"] ?? "",
      type: json["type"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      userName: json["username"] ?? "",
      email: json["email"] ?? "",
      roles: List<String>.from(json['roles'] ?? []),
      name: json['name'] ?? "",
    );
  }
}

class LoginRequestModel {
  String userName;
  String password;

  LoginRequestModel({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': userName.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
