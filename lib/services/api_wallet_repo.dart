// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iclean_mobile_app/auth/user_preferences.dart';
import 'package:iclean_mobile_app/models/api_exception.dart';
import 'package:iclean_mobile_app/models/wallet.dart';
import 'package:iclean_mobile_app/repository/wallet_repo.dart';

import 'components/constant.dart';

class ApiWalletRepository implements WalletRepository {
  static const String urlConstant = "${BaseConstant.baseUrl}/wallet";

  @override
  Future<Wallet> getMoney(BuildContext context) async {
    const url = '$urlConstant?type=money';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final jsonMap = json.decode(utf8.decode(response.bodyBytes));
        final data = jsonMap['data'];
        final money = Wallet.fromJson(data);
        return money;
      } else {
        ResponseHandler.handleResponse(response);
        throw ApiException(response.statusCode, 'Unhandled error occurred');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Wallet> getPoint(BuildContext context) async {
    const url = '$urlConstant?type=point';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final jsonMap = json.decode(utf8.decode(response.bodyBytes));
        final data = jsonMap['data'];
        final point = Wallet.fromJson(data);
        return point;
      } else {
        ResponseHandler.handleResponse(response);
        throw ApiException(response.statusCode, 'Unhandled error occurred');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> createPayment(double amount) async {
    const url = '$urlConstant?type=point';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return '';
      } else {
        throw Exception('Failed to get account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
