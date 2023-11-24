// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iclean_mobile_app/auth/user_preferences.dart';
import 'package:iclean_mobile_app/models/booking_detail.dart';
import 'package:iclean_mobile_app/models/bookings.dart';
import 'package:iclean_mobile_app/models/common_response.dart';
import 'package:iclean_mobile_app/repository/booking_repo.dart';
import 'package:iclean_mobile_app/widgets/error_dialog.dart';

import 'components/constant.dart';

class ApiBookingRepository implements BookingRepository {
  static const String urlConstant = "${BaseConstant.baseUrl}/booking-detail";

  @override
  Future<List<Booking>> getBooking(
      int page, String status, bool isHelper) async {
    final url = '$urlConstant?page=$page&statuses=$status&isHelper=$isHelper';
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
        final content = data['content'] as List;

        final bookings = content.map((e) {
          return Booking.fromJson(e);
        }).toList();
        return bookings;
      } else {
        throw Exception(
            'Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<BookingDetail> getBookingDetailsById(
      BuildContext context, int bookingId) async {
    final url = '$urlConstant/$bookingId';
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

        final bookingDetail = BookingDetail.fromJson(data);

        return bookingDetail;
      } else {
        final jsonMap = json.decode(utf8.decode(response.bodyBytes));
        final responseObject = ResponseObject.fromJson(jsonMap);
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ErrorDialog(responseObject: responseObject),
        );
        throw Exception('Failed to get account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Booking>> getBookingForHelper() async {
    const url = '$urlConstant/helper';
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
        final data = jsonMap['data'] as List;
        final bookings = data.map((e) {
          return Booking.fromJsonForHelper(e);
        }).toList();
        return bookings;
      } else {
        throw Exception(
            'Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
