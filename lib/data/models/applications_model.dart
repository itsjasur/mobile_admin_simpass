import 'package:admin_simpass/data/models/code_value_model.dart';

class ApplicationsInfoModel {
  final List<ApplicationModel> applicationsList;
  final List<CodeValue> usimActStatusCodes;
  final int lastPage;
  final int totalNum;
  final int rowLimit;
  final int currentPage;

  ApplicationsInfoModel({
    required this.applicationsList,
    required this.usimActStatusCodes,
    required this.lastPage,
    required this.totalNum,
    required this.rowLimit,
    required this.currentPage,
  });

  factory ApplicationsInfoModel.fromJson(Map<String, dynamic> map) {
    List<ApplicationModel> applicationsList = (map['act_list'] as List).map((e) => ApplicationModel.fromMap(e)).toList();
    List<CodeValue> usimActStatusCodes = (map['usim_act_status_code'] as List).map((e) => CodeValue.fromJson(e)).toList();

    return ApplicationsInfoModel(
      applicationsList: applicationsList,
      usimActStatusCodes: usimActStatusCodes,
      lastPage: map['lastPage'],
      totalNum: map['totalNum'],
      rowLimit: map['rowLimit'],
      currentPage: map['currentPage'],
    );
  }
}

class ApplicationModel {
  final int num;
  final String? actNo;
  final String? partnerCd;
  final String? partnerNm;
  final String? carrierType;
  final String? carrierTypeNm;
  final String? custType;
  final String? custTypeNm;
  final String? usimActCd;
  final String? usimActCdNm;
  final String? name;
  final String? phoneNumber;
  final String? usimPlanNm;
  final String? carrierCd;
  final String? carrierCdNm;
  final String? mvnoCd;
  final String? usimActStatus;
  final String? usimActStatusNm;
  final String? applyDate;
  final String? actDate;
  final String? signYn;
  final String? signYnNm;
  final String? applyForms;
  final String? attachFiles;
  final String? chkEqYn;

  ApplicationModel({
    required this.num,
    this.actNo,
    this.partnerCd,
    this.partnerNm,
    this.carrierType,
    this.carrierTypeNm,
    this.custType,
    this.custTypeNm,
    this.usimActCd,
    this.usimActCdNm,
    this.name,
    this.phoneNumber,
    this.usimPlanNm,
    this.carrierCd,
    this.carrierCdNm,
    this.mvnoCd,
    this.usimActStatus,
    this.usimActStatusNm,
    this.applyDate,
    this.actDate,
    this.signYn,
    this.signYnNm,
    this.applyForms,
    this.attachFiles,
    this.chkEqYn,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      num: map['num'],
      actNo: map['act_no'],
      partnerCd: map['partner_cd'],
      partnerNm: map['partner_nm'],
      carrierType: map['carrier_type'],
      carrierTypeNm: map['carrier_type_nm'],
      custType: map['cust_type'],
      custTypeNm: map['cust_type_nm'],
      usimActCd: map['usim_act_cd'],
      usimActCdNm: map['usim_act_cd_nm'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      usimPlanNm: map['usim_plan_nm'],
      carrierCd: map['carrier_cd'],
      carrierCdNm: map['carrier_cd_nm'],
      mvnoCd: map['mvno_cd'],
      usimActStatus: map['usim_act_status'],
      usimActStatusNm: map['usim_act_status_nm'],
      applyDate: map['apply_date'],
      actDate: map['act_date'],
      signYn: map['sign_yn'],
      signYnNm: map['sign_yn_nm'],
      applyForms: map['apply_forms'] ?? false,
      attachFiles: map['attach_files'] ?? false,
      chkEqYn: map['chk_eq_yn'],
    );
  }
}

class ApplicationsRequestModel {
  final String actNo;
  final String partnerCd;
  final String usimActStatus;
  final String applyFrDate;
  final String applyToDate;
  final String actFrDate;
  final String actToDate;
  final int page;
  final int rowLimit;

  ApplicationsRequestModel({
    this.actNo = "",
    this.partnerCd = "",
    this.usimActStatus = "",
    this.applyFrDate = "",
    this.applyToDate = "",
    this.actFrDate = "",
    this.actToDate = "",
    required this.page,
    required this.rowLimit,
  });

  // Method to convert the instance back to json
  Map<String, dynamic> toJson() {
    return {
      'act_no': actNo,
      'partner_cd': partnerCd,
      'usim_act_status': usimActStatus,
      'apply_fr_date': applyFrDate,
      'apply_to_date': applyToDate,
      'act_fr_date': actFrDate,
      'act_to_date': actToDate,
      'page': page,
      'rowLimit': rowLimit,
    };
  }
}

class ApplicationStatusUpdatemodel {
  final String actNo;
  final String phoneNumber;
  final String usimActStatus;

  ApplicationStatusUpdatemodel({
    this.actNo = "",
    this.phoneNumber = "",
    this.usimActStatus = "",
  });

  // Method to convert the instance back to json
  Map<String, dynamic> toJson() {
    return {
      "act_no": actNo,
      "phone_number": phoneNumber,
      "usim_act_status": usimActStatus,
    };
  }
}

class ApplicationDetailsModel {
  final String? actNo;
  final String? partnerCd;
  final String? partnerNm;
  final int? regBy;
  final DateTime? regTime;
  final int? updateBy;
  final DateTime? updateTime;
  final String? name;
  final String? idCardType;
  final String? idCardTypeNm;
  final String? idNo;
  final String? birthday;
  final String? contact;
  final String? address;
  final String? countryCd;
  final String? countryNm;
  final String? carrierType;
  final String? carrierTypeNm;
  final String? custType;
  final String? custTypeNm;
  final String? usimActCd;
  final String? usimActNm;
  final String? custCd;
  final String? custNm;
  final String? applyDate;
  final String? actDate;
  final String? cancelDate;
  final String? usimActStatus;
  final String? usimActStatusNm;
  final String? stayDurationFrom;
  final String? stayDurationTo;
  final String? custTypeCd;
  final String? custTypeCdNm;
  final String? gender;
  final int? usimPlanId;
  final String? usimPlanNm;
  final String? carrierCd;
  final String? carrierNm;
  final String? mvnoCd;
  final String? mvnoNm;
  final String? agentCd;
  final String? agentNm;
  final int? basicFee;
  final int? salesFee;
  final int? discountFee;
  final String? extraService;
  final String? requestNo1;
  final String? requestNo2;
  final String? requestNo3;
  final String? phoneModelNo;
  final String? imeiNo;
  final String? usimModelNo;
  final String? usimNo;
  final String? usimFeeCd;
  final String? usimFeeNm;
  final int? usimFee;
  final String? dataBlock;
  final String? dataRomingBlock;
  final String? phoneBillBlock;
  final String? offsetAgree;
  final String? planFeeCd;
  final String? planFee;
  final String? phoneNumber;
  final String? deputyName;
  final String? relationshipCd;
  final String? relationshipNm;
  final String? deputyBirthday;
  final String? deputyContact;
  final String? paidTransferCd;
  final String? paidTransferNm;
  final String? accountName;
  final String? accountBirthday;
  final String? accountAgency;
  final String? accountNumber;
  final String? cardYyMm;
  final String? chkEqYn;
  final String? mnpCarrierType;
  final String? mnpCarrierTypeNm;
  final String? mnpPhoneNumber;
  final String? mnpPreCarrier;
  final String? mnpPreCarrierNm;
  final String? mnpCertType;
  final String? mnpCertTypeNm;
  final String? mnpCertNo;

  final int? installment;
  final int? thisMonthUsageFee;
  final String? notCustSign;
  final String? applySign;
  final String? applySeal;
  final String? agreeSign;
  final String? termsSign;
  final String? termsSeal;
  final String? billSign;
  final String? billSeal;
  final String? deputySign;
  final String? deputySeal;
  final String? partnerSign;
  final String? partnerSeal;
  final String? actSignYn;
  final String? deputySignYn;
  final String? billSignYn;
  final String? termsSignYn;
  final String? attachFilesYn;
  final String? attachFilesNm;
  final String? applyFormFilesNm;
  final String? attachFiles;

  ApplicationDetailsModel({
    this.actNo,
    this.partnerCd,
    this.partnerNm,
    this.regBy,
    this.regTime,
    this.updateBy,
    this.updateTime,
    this.name,
    this.idCardType,
    this.idCardTypeNm,
    this.idNo,
    this.birthday,
    this.contact,
    this.address,
    this.countryCd,
    this.countryNm,
    this.carrierType,
    this.carrierTypeNm,
    this.custType,
    this.custTypeNm,
    this.usimActCd,
    this.usimActNm,
    this.custCd,
    this.custNm,
    this.applyDate,
    this.actDate,
    this.cancelDate,
    this.usimActStatus,
    this.usimActStatusNm,
    this.stayDurationFrom,
    this.stayDurationTo,
    this.custTypeCd,
    this.custTypeCdNm,
    this.gender,
    this.usimPlanId,
    this.usimPlanNm,
    this.carrierCd,
    this.carrierNm,
    this.mvnoCd,
    this.mvnoNm,
    this.agentCd,
    this.agentNm,
    this.basicFee,
    this.salesFee,
    this.discountFee,
    this.extraService,
    this.requestNo1,
    this.requestNo2,
    this.requestNo3,
    this.phoneModelNo,
    this.imeiNo,
    this.usimModelNo,
    this.usimNo,
    this.usimFeeCd,
    this.usimFeeNm,
    this.usimFee,
    this.dataBlock,
    this.dataRomingBlock,
    this.phoneBillBlock,
    this.offsetAgree,
    this.planFeeCd,
    this.planFee,
    this.phoneNumber,
    this.deputyName,
    this.relationshipCd,
    this.relationshipNm,
    this.deputyBirthday,
    this.deputyContact,
    this.paidTransferCd,
    this.paidTransferNm,
    this.accountName,
    this.accountBirthday,
    this.accountAgency,
    this.accountNumber,
    this.cardYyMm,
    this.chkEqYn,
    this.mnpCarrierType,
    this.mnpCarrierTypeNm,
    this.mnpPhoneNumber,
    this.mnpPreCarrier,
    this.mnpPreCarrierNm,
    this.mnpCertType,
    this.mnpCertTypeNm,
    this.mnpCertNo,
    this.installment,
    this.thisMonthUsageFee,
    this.notCustSign,
    this.applySign,
    this.applySeal,
    this.agreeSign,
    this.termsSign,
    this.termsSeal,
    this.billSign,
    this.billSeal,
    this.deputySign,
    this.deputySeal,
    this.partnerSign,
    this.partnerSeal,
    this.actSignYn,
    this.deputySignYn,
    this.billSignYn,
    this.termsSignYn,
    this.attachFilesYn,
    this.attachFilesNm,
    this.applyFormFilesNm,
    this.attachFiles,
  });

  factory ApplicationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailsModel(
      actNo: json['act_no'],
      partnerCd: json['partner_cd'],
      partnerNm: json['partner_nm'],
      regBy: json['reg_by'],
      updateBy: json['update_by'],
      name: json['name'],
      idCardType: json['id_card_type'],
      idCardTypeNm: json['id_card_type_nm'],
      idNo: json['id_no'],
      birthday: json['birthday'],
      contact: json['contact'],
      address: json['address'],
      countryCd: json['country_cd'],
      countryNm: json['country_nm'],
      carrierType: json['carrier_type'],
      carrierTypeNm: json['carrier_type_nm'],
      custType: json['cust_type'],
      custTypeNm: json['cust_type_nm'],
      usimActCd: json['usim_act_cd'],
      usimActNm: json['usim_act_nm'],
      custCd: json['cust_cd'],
      custNm: json['cust_nm'],
      applyDate: json['apply_date'],
      usimActStatus: json['usim_act_status'],
      usimActStatusNm: json['usim_act_status_nm'],
      stayDurationFrom: json['stay_duration_from'],
      stayDurationTo: json['stay_duration_to'],
      custTypeCd: json['cust_type_cd'],
      custTypeCdNm: json['cust_type_cd_nm'],
      gender: json['gender'],
      usimPlanId: json['usim_plan_id'],
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
      extraService: json['extra_service'],
      requestNo1: json['request_no_1'],
      requestNo2: json['request_no_2'],
      requestNo3: json['request_no_3'],
      phoneModelNo: json['phone_model_no'],
      imeiNo: json['imei_no'],
      usimModelNo: json['usim_model_no'],
      usimNo: json['usim_no'],
      usimFeeCd: json['usim_fee_cd'],
      usimFeeNm: json['usim_fee_nm'],
      usimFee: json['usim_fee'],
      dataBlock: json['data_block'],
      dataRomingBlock: json['data_roming_block'],
      phoneBillBlock: json['phone_bill_block'],
      offsetAgree: json['offset_agree'],
      planFeeCd: json['plan_fee_cd'],
      planFee: json['plan_fee'],
      phoneNumber: json['phone_number'],
      deputyName: json['deputy_name'],
      relationshipCd: json['relationship_cd'],
      relationshipNm: json['relationship_nm'],
      deputyBirthday: json['deputy_birthday'],
      deputyContact: json['deputy_contact'],
      paidTransferCd: json['paid_transfer_cd'],
      paidTransferNm: json['paid_transfer_nm'],
      accountName: json['account_name'],
      accountBirthday: json['account_birthday'],
      accountAgency: json['account_agency'],
      accountNumber: json['account_number'],
      cardYyMm: json['card_yy_mm'],
      chkEqYn: json['chk_eq_yn'],
      mnpCarrierType: json['mnp_carrier_type'],
      mnpCarrierTypeNm: json['mnp_carrier_type_nm'],
      mnpPhoneNumber: json['mnp_phone_number'],
      mnpPreCarrier: json['mnp_pre_carrier'],
      mnpPreCarrierNm: json['mnp_pre_carrier_nm'],
      mnpCertType: json['mnp_cert_type'],
      mnpCertTypeNm: json['mnp_cert_type_nm'],
      mnpCertNo: json['mnp_cert_no'],
      installment: json['installment'],
      thisMonthUsageFee: json['this_month_usage_fee'],
      notCustSign: json['not_cust_sign'],
      applySign: json['apply_sign'],
      applySeal: json['apply_seal'],
      agreeSign: json['agree_sign'],
      termsSign: json['terms_sign'],
      termsSeal: json['terms_seal'],
      billSign: json['bill_sign'],
      billSeal: json['bill_seal'],
      deputySign: json['deputy_sign'],
      deputySeal: json['deputy_seal'],
      partnerSign: json['partner_sign'],
      partnerSeal: json['partner_seal'],
      actSignYn: json['act_sign_yn'],
      deputySignYn: json['deputy_sign_yn'],
      billSignYn: json['bill_sign_yn'],
      termsSignYn: json['terms_sign_yn'],
      attachFilesYn: json['attach_files_yn'],
      attachFilesNm: json['attach_files_nm'],
      applyFormFilesNm: json['apply_form_files_nm'],
      attachFiles: json['attach_files'],
    );
  }
}
