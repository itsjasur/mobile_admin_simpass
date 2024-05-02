class ProfileResponseModel {
  int? regBy;
  String? regTime;
  int? updateBy;
  String? updateTime;
  int? id;
  String? username;
  String? password;
  String? name;
  String? country;
  String? countryNm;
  String? phoneNumber;
  String? email;
  String? fromDate;
  String? expireDate;
  String? status;
  String? statusNm;
  List? roles;
  List? strRoles;
  Map? countryValue;
  Map? statusValue;
  List? rolesValue;

  ProfileResponseModel({
    this.regBy,
    this.regTime,
    this.updateBy,
    this.updateTime,
    this.id,
    this.username,
    this.password,
    this.name,
    this.country,
    this.countryNm,
    this.phoneNumber,
    this.email,
    this.fromDate,
    this.expireDate,
    this.status,
    this.statusNm,
    this.roles,
    this.strRoles,
    this.countryValue,
    this.statusValue,
    this.rolesValue,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
        regBy: json['reg_by'],
        regTime: json['reg_time'],
        updateBy: json['update_by'],
        updateTime: json['update_time'],
        id: json['id'],
        username: json['username'],
        password: json['password'],
        name: json['name'],
        country: json['country'],
        countryNm: json['country_nm'],
        phoneNumber: json['phone_number'],
        email: json['email'],
        fromDate: json['from_date'],
        expireDate: json['expire_date'],
        status: json['status'],
        statusNm: json['status_nm'],
        roles: json['roles'],
        strRoles: json['strRoles'],
        countryValue: json['country_value'],
        statusValue: json['status_value'],
        rolesValue: json['roles_value'],
      );

  Map<String, dynamic> toJson() => {
        'reg_by': regBy,
        'reg_time': regTime,
        'update_by': updateBy,
        'update_time': updateTime,
        'id': id,
        'username': username,
        'password': password,
        'name': name,
        'country': country,
        'country_nm': countryNm,
        'phone_number': phoneNumber,
        'email': email,
        'from_date': fromDate,
        'expire_date': expireDate,
        'status': status,
        'status_nm': statusNm,
        'roles': roles,
        'strRoles': strRoles,
        'country_value': countryValue,
        'status_value': statusValue,
        'roles_value': rolesValue?.map((e) => e.toJson()).toList(),
      };
}

class ProfileUpdateRequestModel {
  int id;
  String username;
  String name;
  String country;
  String phoneNumber;
  String email;

  ProfileUpdateRequestModel({
    required this.id,
    required this.username,
    required this.name,
    required this.country,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "country": country,
        "phone_number": phoneNumber,
        "email": email,
      };
}
