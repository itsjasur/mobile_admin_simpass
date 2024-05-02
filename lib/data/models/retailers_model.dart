import 'package:admin_simpass/data/models/code_value_model.dart';

class RetailersModel {
  int? lastPage;
  int? totalNum;
  List<PartnerModel> partnerList;
  List<CodeValue> statusList;
  int? rowLimit;
  int? currentPage;

  RetailersModel({
    this.lastPage,
    this.totalNum,
    required this.partnerList,
    required this.statusList,
    this.rowLimit,
    this.currentPage,
  });

  factory RetailersModel.fromJson(Map<String, dynamic> json) {
    var partnerList = json['partner_list'] as List;
    List<PartnerModel> partners = partnerList.map((partner) => PartnerModel.fromJson(partner)).toList();

    var statusList = json['status_list'] as List;
    List<CodeValue> statuses = statusList.map((status) => CodeValue.fromJson(status)).toList();

    return RetailersModel(
      lastPage: json['lastPage'],
      totalNum: json['totalNum'],
      partnerList: partners,
      statusList: statuses,
      rowLimit: json['rowLimit'],
      currentPage: json['currentPage'],
    );
  }
}

class PartnerModel {
  int? num;
  int? id;
  String? partnerCd;
  String? contractor;
  String? birthday;
  String? partnerNm;
  String? phoneNumber;
  String? businessNum;
  String? idCardType;
  String? idCardTypeNm;
  String? idNo;
  String? driverNo;
  String? idIssuedDate;
  String? storeContact;
  String? storeFax;
  String? address;
  String? dtlAddress;
  String? email;
  String? salesCd;
  String? applyDate;
  String? contractDate;
  String? bankNm;
  String? bankNum;
  String? idCertType;
  String? receiptId;
  String? bsRegNo;
  String? idCard;
  String? bankBook;
  String? priorConsentForm;
  String? contract;
  String? shopInfo1;
  String? shopInfo2;
  String? partnerSign;
  String? partnerSeal;
  String? fromDate;
  String? expireDate;
  String? status;
  String? statusNm;
  int? regBy;
  String? regTime;
  int? updateBy;
  String? updateTime;
  String? bsRegNoAttach;
  String? idCardAttach;
  String? bankBookAttach;
  String? priorConsentFormAttach;
  String? shopInfo1Attach;
  String? shopInfo2Attach;

  PartnerModel({
    this.num,
    this.id,
    this.partnerCd,
    this.contractor,
    this.birthday,
    this.partnerNm,
    this.phoneNumber,
    this.businessNum,
    this.idCardType,
    this.idCardTypeNm,
    this.idNo,
    this.driverNo,
    this.idIssuedDate,
    this.storeContact,
    this.storeFax,
    this.address,
    this.dtlAddress,
    this.email,
    this.salesCd,
    this.applyDate,
    this.contractDate,
    this.bankNm,
    this.bankNum,
    this.idCertType,
    this.receiptId,
    this.bsRegNo,
    this.idCard,
    this.bankBook,
    this.priorConsentForm,
    this.contract,
    this.shopInfo1,
    this.shopInfo2,
    this.partnerSign,
    this.partnerSeal,
    this.fromDate,
    this.expireDate,
    this.status,
    this.statusNm,
    this.regBy,
    this.regTime,
    this.updateBy,
    this.updateTime,
    this.bsRegNoAttach,
    this.idCardAttach,
    this.bankBookAttach,
    this.priorConsentFormAttach,
    this.shopInfo1Attach,
    this.shopInfo2Attach,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      num: json['num'],
      id: json['id'],
      partnerCd: json['partner_cd'],
      contractor: json['contractor'],
      birthday: json['birthday'],
      partnerNm: json['partner_nm'],
      phoneNumber: json['phone_number'],
      businessNum: json['business_num'],
      idCardType: json['id_card_type'],
      idCardTypeNm: json['id_card_type_nm'],
      idNo: json['id_no'],
      driverNo: json['driver_no'],
      idIssuedDate: json['id_issued_date'],
      storeContact: json['store_contact'],
      storeFax: json['store_fax'],
      address: json['address'],
      dtlAddress: json['dtl_address'],
      email: json['email'],
      salesCd: json['sales_cd'],
      applyDate: json['apply_date'],
      contractDate: json['contract_date'],
      bankNm: json['bank_nm'],
      bankNum: json['bank_num'],
      idCertType: json['id_cert_type'],
      receiptId: json['receipt_id'],
      bsRegNo: json['bs_reg_no'],
      idCard: json['id_card'],
      bankBook: json['bank_book'],
      priorConsentForm: json['prior_consent_form'],
      contract: json['contract'],
      shopInfo1: json['shop_info_1'],
      shopInfo2: json['shop_info_2'],
      partnerSign: json['partner_sign'],
      partnerSeal: json['partner_seal'],
      fromDate: json['from_date'],
      expireDate: json['expire_date'],
      status: json['status'],
      statusNm: json['status_nm'],
      regBy: json['reg_by'],
      regTime: json['reg_time'],
      updateBy: json['update_by'],
      updateTime: json['update_time'],
      bsRegNoAttach: json['bs_reg_no_attach'],
      idCardAttach: json['id_card_attach'],
      bankBookAttach: json['bank_book_attach'],
      priorConsentFormAttach: json['prior_consent_form_attach'],
      shopInfo1Attach: json['shop_info_1_attach'],
      shopInfo2Attach: json['shop_info_2_attach'],
    );
  }
}
