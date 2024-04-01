import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';

var client = http.Client();

final meetingProvider = ChangeNotifierProvider<Meeting>((ref) => Meeting());

class Meeting extends ChangeNotifier {
  Future<http.Response?> startMeeting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('x-auth-token');
    final String? uid = prefs.getString('uid');
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    var response = await client.post(Uri.parse('$host/meeting/start'),
        headers: requestHeaders,
        body: jsonEncode({'hostId': uid, 'hostName': ''}));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<http.Response> joinMeeting(String meetingId) async {
    var response =
        await http.get(Uri.parse('$host/meeting/join?meetingId=$meetingId'));
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return response;
    }
    throw UnsupportedError('Not a valid Meeting');
  }
}
