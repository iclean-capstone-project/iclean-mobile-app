// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:iclean_mobile_app/auth/user_preferences.dart';
import 'package:iclean_mobile_app/models/noti.dart';
import 'package:iclean_mobile_app/repository/noti_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:iclean_mobile_app/services/constant.dart';

class ApiNotiRepository implements NotiRepository {
  static const String urlConstant = "${BaseConstant.baseUrl}/notification";

  @override
  Future<List<Noti>> getNoti(int page) async {
    final url = '$urlConstant?page=$page';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    // Create a headers map with the "Authorization" header
    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonMap = json.decode(utf8.decode(response.bodyBytes));
        final data = jsonMap['data'];
        final content = data['content'] as List<dynamic>;
        final notifications = content.map((e) {
          return Noti(
            id: e['notificationId'],
            details: e['content'],
            imgLink: e['notificationImgLink'],
            timestamp: DateTime.parse(e['createAt']),
            isRead: e['isRead'],
          );
        }).toList();
        return notifications;
      } else {
        return throw Exception(
            'status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> readAll() async {
    const url = urlConstant;
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    try {
      final response = await http.put(uri, headers: headers);
      if (response.statusCode == 200) {
        print('update succesful');
      } else {
        throw Exception(
            'Failed to update notifications. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> maskAsRead(int notiId) async {
    final url = '$urlConstant/$notiId';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    try {
      final response = await http.put(uri, headers: headers);
      if (response.statusCode == 200) {
        print('update succesful');
      } else {
        throw Exception(
            'Failed to update notifications. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteNoti(int notiId) async {
    final url = '$urlConstant/$notiId';
    final uri = Uri.parse(url);
    final accessToken = await UserPreferences.getAccessToken();

    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    try {
      final response = await http.delete(uri, headers: headers);
      if (response.statusCode == 200) {
        print('deleted succesful');
      } else {
        throw Exception(
            'Failed to update notifications. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}