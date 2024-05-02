class SignupResponseModel {
  final String message;

  SignupResponseModel({
    required this.message,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      message: json["message"] ?? "",
    );
  }
}

class SignupRequestModel {
  final String userName;
  final String password;
  final String email;
  final String fullName;
  final String country;
  final String phoneNumber;

  SignupRequestModel({
    required this.userName,
    required this.password,
    required this.email,
    required this.fullName,
    required this.country,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "username": userName.trim(),
      "password": password.trim(),
      "email": email.trim(),
      "name": fullName.trim(),
      "country": "KR",
      "phone_number": phoneNumber.trim(),
    };

    return map;
  }
}
