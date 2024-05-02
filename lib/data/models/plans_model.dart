import 'package:admin_simpass/data/models/code_value_model.dart';

class ManagePlansModel {
  final List<CodeValue> carrierType;
  final List<CodeValue> mvnoCd;
  final List<CodeValue> carrierPlanType;
  final int lastPage;
  final List<CodeValue> statusCd;
  final int totalNum;
  final List<CodeValue> agentCd;
  final List<CodeValue> carrierCd;
  final List<PlanModel> planList;
  final int rowLimit;
  final int currentPage;

  ManagePlansModel({
    required this.carrierType,
    required this.mvnoCd,
    required this.carrierPlanType,
    required this.lastPage,
    required this.statusCd,
    required this.totalNum,
    required this.agentCd,
    required this.carrierCd,
    required this.planList,
    required this.rowLimit,
    required this.currentPage,
  });

  factory ManagePlansModel.fromJson(Map<String, dynamic> json) {
    return ManagePlansModel(
      carrierType: List<CodeValue>.from(json['carrier_type'].map((x) => CodeValue.fromJson(x))),
      mvnoCd: List<CodeValue>.from(json['mvno_cd'].map((x) => CodeValue.fromJson(x))),
      carrierPlanType: List<CodeValue>.from(json['carrier_plan_type'].map((x) => CodeValue.fromJson(x))),
      lastPage: json['lastPage'],
      statusCd: List<CodeValue>.from(json['status_cd'].map((x) => CodeValue.fromJson(x))),
      totalNum: json['totalNum'],
      agentCd: List<CodeValue>.from(json['agent_cd'].map((x) => CodeValue.fromJson(x))),
      carrierCd: List<CodeValue>.from(json['carrier_cd'].map((x) => CodeValue.fromJson(x))),
      planList: List<PlanModel>.from(json['plan_list'].map((x) => PlanModel.fromJson(x))),
      rowLimit: json['rowLimit'],
      currentPage: json['currentPage'],
    );
  }
}

class PlanModel {
  int? num;
  final int id;
  final String usimPlanNm;
  final String carrierCd;
  final String carrierNm;
  final String mvnoCd;
  final String mvnoNm;
  final String agentCd;
  final String agentNm;
  final int basicFee;
  final int salesFee;
  int? discountFee;
  String? voice;
  String? message;
  String? cellData;
  String? videoEtc;
  String? qos;
  final String carrierPlanType;
  String? carrierPlanTypeNm;
  final String carrierType;
  String? carrierTypeNm;
  int? usimFee;
  int? planFee;
  String? fromDate;
  String? expireDate;
  final String status;
  String? statusNm;
  int? regBy;
  String? regTime;
  int? updateBy;
  String? updateTime;
  int? priority;

  PlanModel({
    this.num,
    required this.id,
    required this.usimPlanNm,
    required this.carrierCd,
    required this.carrierNm,
    required this.mvnoCd,
    required this.mvnoNm,
    required this.agentCd,
    required this.agentNm,
    required this.basicFee,
    required this.salesFee,
    this.discountFee,
    this.voice,
    this.message,
    this.cellData,
    this.videoEtc,
    this.qos,
    required this.carrierPlanType,
    this.carrierPlanTypeNm,
    required this.carrierType,
    this.carrierTypeNm,
    this.usimFee,
    this.planFee,
    this.fromDate,
    this.expireDate,
    required this.status,
    this.statusNm,
    this.regBy,
    this.regTime,
    this.updateBy,
    this.updateTime,
    this.priority,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      num: json['num'],
      id: json['id'],
      usimPlanNm: json['usim_plan_nm'],
      carrierCd: json['carrier_cd'],
      carrierNm: json['carrier_nm'],
      mvnoCd: json['mvno_cd'],
      mvnoNm: json['mvno_nm'],
      agentCd: json['agent_cd'],
      agentNm: json['agent_nm'],
      basicFee: json['basic_fee'],
      salesFee: json['sales_fee'],
      discountFee: json['discount_fee'],
      voice: json['voice'],
      message: json['message'],
      cellData: json['cell_data'],
      videoEtc: json['video_etc'],
      qos: json['qos'],
      carrierPlanType: json['carrier_plan_type'],
      carrierPlanTypeNm: json['carrier_plan_type_nm'],
      carrierType: json['carrier_type'],
      carrierTypeNm: json['carrier_type_nm'],
      usimFee: json['usim_fee'],
      planFee: json['plan_fee'],
      fromDate: json['from_date'],
      expireDate: json['expire_date'],
      status: json['status'],
      statusNm: json['status_nm'],
      regBy: json['reg_by'],
      regTime: json['reg_time'],
      updateBy: json['update_by'] ?? 0,
      updateTime: json['update_time'],
      priority: json['priority'],
    );
  }
}

class ManagePlanSearchModel {
  String usimPlanNm; // 요금제명
  String carrierCd; // 통신사
  String mvnoCd; // 브랜드
  String agentCd; // 대리점
  String carrierPlanType; // 가입대상
  String carrierType; // 서비스유형
  String status; // 상태
  int page;
  int rowLimit;

  ManagePlanSearchModel({
    this.usimPlanNm = '',
    this.carrierCd = '',
    this.mvnoCd = '',
    this.agentCd = '',
    this.carrierPlanType = '',
    this.carrierType = '',
    this.status = '',
    this.page = 1,
    this.rowLimit = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'usim_plan_nm': usimPlanNm,
      'carrier_cd': carrierCd,
      'mvno_cd': mvnoCd,
      'agent_cd': agentCd,
      'carrier_plan_type': carrierPlanType,
      'carrier_type': carrierType,
      'status': status,
      'page': page,
      'rowLimit': rowLimit,
    };
  }

  ManagePlanSearchModel copyWith({
    String? usimPlanNm,
    String? carrierCd,
    String? mvnoCd,
    String? agentCd,
    String? carrierPlanType,
    String? carrierType,
    String? status,
    int? page,
    int? rowLimit,
  }) {
    return ManagePlanSearchModel(
      usimPlanNm: usimPlanNm ?? this.usimPlanNm,
      carrierCd: carrierCd ?? this.carrierCd,
      mvnoCd: mvnoCd ?? this.mvnoCd,
      agentCd: agentCd ?? this.agentCd,
      carrierPlanType: carrierPlanType ?? this.carrierPlanType,
      carrierType: carrierType ?? this.carrierType,
      status: status ?? this.status,
      page: page ?? this.page,
      rowLimit: rowLimit ?? this.rowLimit,
    );
  }

  // Method to check if any of the specified fields are not empty
  bool hasFilledFields() {
    return agentCd.isNotEmpty || carrierCd.isNotEmpty || carrierPlanType.isNotEmpty || carrierType.isNotEmpty || mvnoCd.isNotEmpty || status.isNotEmpty;
  }

  int? countNonEmptyFields() {
    List<String> fields = [
      carrierCd,
      mvnoCd,
      agentCd,
      carrierPlanType,
      carrierType,
      status,
    ];
    int count = fields.fold(0, (int sum, String field) => sum + (field.isNotEmpty ? 1 : 0));
    return count == 0 ? null : count;
  }
}

class PlanAddUpdateModel {
  final int? id;
  final String usimPlanNm;
  final String carrierCd;
  final String mvnoCd;
  final String agentCd;
  final int basicFee;
  final int salesFee;

  final String? voice;
  final String? message;
  final String? cellData;
  final String? videoEtc;
  final String? qos;
  final String carrierPlanType;
  final String carrierType;
  final int? usimFee;
  final int? planFee;
  final int? priority;
  final String? status;

  PlanAddUpdateModel({
    required this.id,
    required this.usimPlanNm,
    required this.carrierCd,
    required this.mvnoCd,
    required this.agentCd,
    required this.basicFee,
    required this.salesFee,
    required this.voice,
    required this.message,
    required this.cellData,
    this.videoEtc,
    this.qos,
    required this.carrierPlanType,
    required this.carrierType,
    this.usimFee,
    this.planFee,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usim_plan_nm': usimPlanNm,
      'carrier_cd': carrierCd,
      'mvno_cd': mvnoCd,
      'agent_cd': agentCd,
      'basic_fee': basicFee,
      'sales_fee': salesFee,
      'voice': voice,
      'message': message,
      'cell_data': cellData,
      'video_etc': videoEtc,
      'qos': qos,
      'carrier_plan_type': carrierPlanType,
      'carrier_type': carrierType,
      'usim_fee': usimFee,
      'plan_fee': planFee,
      'priority': priority,
      'status': status,
    };
  }
}
