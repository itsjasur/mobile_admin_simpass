import 'package:admin_simpass/data/models/code_value_model.dart';

class CustomerRequestsModel {
  int? lastPage;
  int? totalNum;
  List<CodeValue>? statusList;
  int? rowLimit;
  List<CodeValue>? countryList;
  int? currentPage;
  List<CustomerRequestModel>? applyList;

  CustomerRequestsModel({
    required this.lastPage,
    required this.totalNum,
    required this.statusList,
    required this.rowLimit,
    required this.countryList,
    required this.currentPage,
    required this.applyList,
  });

  factory CustomerRequestsModel.fromJson(Map<String?, dynamic> json) {
    return CustomerRequestsModel(
      lastPage: json['lastPage'],
      totalNum: json['totalNum'],
      statusList: (json['status_list'] as List).map((status) => CodeValue.fromJson(status)).toList(),
      rowLimit: json['rowLimit'],
      countryList: (json['country_list'] as List).map((country) => CodeValue.fromJson(country)).toList(),
      currentPage: json['currentPage'],
      applyList: (json['apply_list'] as List).map((apply) => CustomerRequestModel.fromJson(apply)).toList(),
    );
  }
}

class CustomerRequestModel {
  int? num;
  int? id;
  String? name;
  String? contact;
  String? countryCd;
  String? countryNm;
  String? planId;
  String? planNm;
  String? usimActCd;
  String? usimActNm;
  String? status;
  String? statusNm;
  int? regBy;
  String? regTime;
  int? updateBy;
  String? updateTime;

  CustomerRequestModel({
    required this.num,
    required this.id,
    required this.name,
    required this.contact,
    required this.countryCd,
    required this.countryNm,
    required this.planId,
    required this.planNm,
    required this.usimActCd,
    required this.usimActNm,
    required this.status,
    required this.statusNm,
    required this.regBy,
    required this.regTime,
    required this.updateBy,
    required this.updateTime,
  });

  factory CustomerRequestModel.fromJson(Map<String?, dynamic> json) {
    return CustomerRequestModel(
      num: json['num'],
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      countryCd: json['country_cd'],
      countryNm: json['country_nm'],
      planId: json['plan_id'],
      planNm: json['plan_nm'],
      usimActCd: json['usim_act_cd'],
      usimActNm: json['usim_act_nm'],
      status: json['status'],
      statusNm: json['status_nm'],
      regBy: json['reg_by'],
      regTime: json['reg_time'],
      updateBy: json['update_by'],
      updateTime: json['update_time'],
    );
  }
}
