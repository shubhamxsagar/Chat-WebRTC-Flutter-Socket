import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/models/user_model.dart';
import 'package:the_haha_guys/repo/services.dart';

final userContollerProvider = Provider((ref) {
  final services = ref.watch(serviceProvider);
  return UserController(services: services);
});

class UserController extends ChangeNotifier {
  final Services _services;

  UserController({required Services services}) : _services = services;
  Future<UserModel?> getUser(String token) async {
    try {
      final response = await _services.getResponse(token);
      if (response.statusCode == 200) {
        // final Map<String, dynamic> data = jsonDecode(response.body);
        final data =
            UserModel.fromJson(jsonEncode(jsonDecode(response.body)['user']));
        // logger.w(data['user']);
        // return UserModel.fromJson(data['user']);
        // logger.e(UserModel.fromJson(jsonDecode(response.body)['user']));
        logger.e(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      // logger.w(e);
      rethrow;
    }
  }
}
