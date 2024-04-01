import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/core/common/logger.dart';

final getlocalStorage =
    ChangeNotifierProvider<LocalStorageRepository>((ref) => LocalStorageRepository());

class LocalStorageRepository extends ChangeNotifier {
  void setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }

  void setUid(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('uid', uid);
  }

  Future<String> getUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString('uid') ?? '';
    logger.e('UID Local Storage: $uid');
    return uid;
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('x-auth-token') ?? '';
    return token;
  }
}
