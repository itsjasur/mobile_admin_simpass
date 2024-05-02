import 'dart:convert';
import 'package:admin_simpass/data/api/request_helper.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/data/models/customer_requests_model.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/member_model.dart';
import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/data/models/retailers_model.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  Uri _urlMaker(String endpoint) {
    return Uri.parse(BASEURL + endpoint);
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    return accessToken;
  }

  var headers = {'Content-Type': 'application/json; charset=utf-8'};

  Future<void> login(BuildContext context, LoginRequestModel requestModel) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    try {
      final response = await http.post(_urlMaker('auth/signin'), headers: headers, body: json.encode(requestModel.toJson()));
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        LoginResponseModel loginResponse = LoginResponseModel.fromJson(decodedResponse);
        if (context.mounted) {
          await Provider.of<AuthServiceProvider>(context, listen: false).loggedIn(context, loginResponse.token, loginResponse.refreshToken);
        }
        if (context.mounted) await Provider.of<MyinfoProvifer>(context, listen: false).updateRoles(loginResponse.roles);
      } else {
        throw 'Incorrect credentials';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> signup(BuildContext context, SignupRequestModel requestModel) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    try {
      final response = await http.post(_urlMaker('auth/signup'), headers: headers, body: json.encode(requestModel.toJson()));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        }
      } else {
        throw Exception('Sign up data error');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<ProfileResponseModel> profileInfo(BuildContext context) async {
    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';
      Uri url = _urlMaker('admin/myInfo');
      var response = await http.get(url, headers: headers);
      response = await RequestHelper().get(context.mounted ? context : null, response, url, headers);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        if (decodedResponse != null && decodedResponse['data'] != null && decodedResponse['data']['result'] == 'SUCCESS' && decodedResponse['data']['info'] != null) {
          return ProfileResponseModel.fromJson(decodedResponse['data']['info']);
        }
      }

      throw "Profile response data not reveiced";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> profileInfoUpdate(BuildContext context, ProfileUpdateRequestModel requestModel) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';
      Uri url = _urlMaker('admin/myUpdate');

      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        }
      } else {
        throw "Update data incorrect";
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<Map> fetchUsers({required BuildContext context, required page, required rowLimit}) async {
    String? accessToken = await getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
    Uri url = _urlMaker('admin/member');
    var body = json.encode({
      "page": page,
      "rowLimit": rowLimit,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        throw "Could not fetch data";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MemberModel> fetchMemberInfo({required BuildContext context, required String memberUserName}) async {
    String? accessToken = await getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';
    Uri url = _urlMaker('admin/memberDetail');

    var body = json.encode({"username": memberUserName});

    try {
      var response = await http.post(url, headers: headers, body: body);
      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        return MemberModel.fromJson(decodedResponse["data"]["info"]);
      } else {
        throw "Could not fetch data";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> memberUpdate({required BuildContext context, required MemberUpdate requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/memberUpdate');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
      } else {
        throw decodedResponse['message'] ?? "Update data incorrect";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> memberRegister({required BuildContext context, required MemberRegister requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/register');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
      } else {
        throw decodedResponse['message'] ?? "Update data incorrect";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<ManagePlansModel> fetchPlansInfo({required BuildContext context, required ManagePlanSearchModel requestModel}) async {
    try {
      String? accessToken = await getAccessToken();

      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/plan');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return ManagePlansModel.fromJson(decodedResponse['data']);
      } else {
        throw decodedResponse['message'] ?? "Plans data request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrAddPlan({required BuildContext context, required PlanAddUpdateModel requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/setPlan');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        return true;
      } else {
        throw decodedResponse['message'] ?? "Data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }

  Future<ApplicationsInfoModel> fetchApplications({required BuildContext context, required ApplicationsRequestModel requestModel}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/actStatus');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      // print(jsonEncode(decodedResponse));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return ApplicationsInfoModel.fromJson(decodedResponse["data"]);
      } else {
        throw decodedResponse['message'] ?? "Applications request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateApplicationStatus({required BuildContext context, required ApplicationStatusUpdatemodel requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/setApplyStatus');
      var body = json.encode(requestModel.toJson());
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      // print(jsonEncode(decodedResponse));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        return true;
      } else {
        throw decodedResponse['message'] ?? "Applications request data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }

    return false;
  }

  Future<ApplicationDetailsModel> fetchApplicationDetails({required BuildContext context, required String applicationId}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/actDetail');
      var body = json.encode({"act_no": applicationId});
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      // print(jsonEncode(decodedResponse));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return ApplicationDetailsModel.fromJson(decodedResponse["data"]['act_detail_info']);
      } else {
        throw decodedResponse['message'] ?? "Application details request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List> fetchApplicationAttachs({required BuildContext context, required String applicationId}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/actAttachs');
      var body = json.encode({"act_no": applicationId});
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        if (decodedResponse["data"]['apply_attach_list'] == null || decodedResponse["data"]['apply_attach_list'].isEmpty) {
          throw "목록이 비어 있습니다.";
        } else {
          return decodedResponse["data"]['apply_attach_list'];
        }
      } else {
        throw decodedResponse['message'] ?? "Application details images request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchApplicationForms({required BuildContext context, required String applicationId}) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/actForms');
      var body = json.encode({"act_no": applicationId});
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        if (decodedResponse["data"]['apply_forms_list'] == null || decodedResponse["data"]['apply_forms_list'].isEmpty) {
          throw "목록이 비어 있습니다.";
        } else {
          List<dynamic> applyFormsList = decodedResponse["data"]['apply_forms_list'];
          List<String> stringFormsList = applyFormsList.map((e) => e.toString()).toList();
          return stringFormsList;
        }
      } else {
        throw decodedResponse['message'] ?? "Application details images request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RetailersModel> fetchRetailers({required BuildContext context, Map? requestModel}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/partner');
      var body = json.encode(requestModel);
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      // print(jsonEncode(decodedResponse));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return RetailersModel.fromJson(decodedResponse["data"]);
      } else {
        throw decodedResponse['message'] ?? "Retailer request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateRetailerStatus({required BuildContext context, required Map requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/setPartnerStatus');
      var body = json.encode(requestModel);
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        return true;
      } else {
        throw decodedResponse['message'] ?? "Retailer request data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }

  Future<PartnerModel> fetchRetailerDetails({required BuildContext context, required String retailerCode}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/partnerDetail');
      var body = json.encode({"partner_cd": retailerCode});
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return PartnerModel.fromJson(decodedResponse["data"]['partner_info']);
      } else {
        throw decodedResponse['message'] ?? "Retailer details request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> fetchRetailerImageByFileName({required BuildContext context, required String retailerCode, required String fileName}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('agent/partnerAttach');
      var body = json.encode({
        "partner_cd": retailerCode,
        "file_name": fileName,
      });

      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        if (decodedResponse["data"]['image'] == null) throw "목록이 비어 있습니다.";
        return decodedResponse["data"]['image'];
      } else {
        throw decodedResponse['message'] ?? "Retailer image request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerRequestsModel> fetchCustomerRequests({required BuildContext context, required Map requestModel}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/selfInquiry');
      var body = json.encode(requestModel);
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return CustomerRequestsModel.fromJson(decodedResponse["data"]);
      } else {
        throw decodedResponse['message'] ?? "Applications request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateCustomerRequestStatus({required BuildContext context, required Map requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/setSelfInquStatus');
      var body = json.encode(requestModel);
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        messenger.showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        return true;
      } else {
        throw decodedResponse['message'] ?? "Retailer request data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }

  Future<CustomerRequestModel> fetchCustomerRequestDetails({required BuildContext context, required int id}) async {
    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/selfInquDtl');
      var body = json.encode({"id": id});
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);

      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decodedResponse['result'] == 'SUCCESS') {
        return CustomerRequestModel.fromJson(decodedResponse["data"]['apply_detail_info']);
      } else {
        throw decodedResponse['message'] ?? "Retailer details request data error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changeMyPassword({required BuildContext context, required Map requestModel}) async {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      String? accessToken = await getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';

      Uri url = _urlMaker('admin/myPassword');
      var body = json.encode(requestModel);
      var response = await http.post(url, headers: headers, body: body);

      response = await RequestHelper().post(context.mounted ? context : null, response, url, headers, body);
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw decodedResponse['message'] ?? "Password change data error";
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}
