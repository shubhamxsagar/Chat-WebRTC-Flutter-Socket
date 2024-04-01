import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';

final serviceProvider = Provider((ref) => Services());

class Services {
  Future<http.Response> getResponse(String token) async {
    try {
      final url = Uri.parse('$host/user');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      // log(response.body as num);
      // if (response.statusCode == 200) {
      return response;
      // }
    } catch (e) {
      logger.w(e);
      rethrow;
    }
  }
}
