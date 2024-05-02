class UserModel {
  int id;
  String username;
  String name;
  String country;
  String countryNm;
  String phoneNumber;
  String email;
  String status;
  String fromDate;
  String expireDate;
  String statusNm;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.country,
    required this.countryNm,
    required this.phoneNumber,
    required this.email,
    required this.fromDate,
    required this.expireDate,
    required this.status,
    required this.statusNm,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      name: json['name'] ?? "",
      country: json['country'] ?? "",
      countryNm: json['country_nm'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      fromDate: json['from_date'] ?? "",
      expireDate: json['expire_date'] ?? "",
      status: json['status'] ?? "",
      statusNm: json['status_nm'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'country': country,
      'country_nm': countryNm,
      'phone_number': phoneNumber,
      'email': email,
      'from_date': fromDate,
      'expire_date': expireDate,
      'status': status,
      'status_nm': statusNm,
    };
  }
}
