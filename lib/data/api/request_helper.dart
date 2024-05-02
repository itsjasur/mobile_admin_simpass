import 'dart:convert';

import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/sensitive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//this checkes if error response if 401, and tries to get token and retries the request
class RequestHelper {
  Uri _urlMaker(String endpoint) {
    return Uri.parse(BASEURL + endpoint);
  }

  Future<String?> _accessTokenRefreshed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');
    if (refreshToken != null) {
      try {
        final response = await http.post(
          _urlMaker('auth/refreshtoken'),
          body: json.encode({"refreshToken": refreshToken}),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
        );

        if (response.statusCode == 200) {
          var result = json.decode(utf8.decode(response.bodyBytes));
          await prefs.setString('accessToken', result['accessToken']);
          await prefs.setString('refreshToken', result['refreshToken']);
          return result['accessToken'];
        }
      } catch (e) {
        rethrow;
      }
    }
    return null;
  }

  //this checkes if there is any error in the post request response
  Future<Response> post(BuildContext? context, Response response, Uri url, Map<String, String> headers, Object? body) async {
    try {
      if (response.statusCode == 401) {
        String? newAccessToken = await _accessTokenRefreshed();

        if (newAccessToken != null) {
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await http.post(url, headers: headers, body: body);
          return response;
        } else {
          if (context != null && context.mounted) {
            Provider.of<AuthServiceProvider>(context, listen: false).loggedOut(context);
          }
          throw "Expired token. Login again";
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //this checkes if there is any error in the post request response
  Future<Response> get(BuildContext? context, Response response, Uri url, Map<String, String> headers) async {
    if (response.statusCode == 401) {
      String? newAccessToken = await _accessTokenRefreshed();

      if (newAccessToken != null) {
        headers['Authorization'] = 'Bearer $newAccessToken';
        response = await http.get(url, headers: headers);
      } else {
        if (context != null && context.mounted) {
          Provider.of<AuthServiceProvider>(context, listen: false).loggedOut(context);
          throw "Expired token. Login again";
        }
      }
    }
    return response;
  }
}
