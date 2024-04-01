import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/shared_preferences/loacl_storage.dart';
import 'package:http/http.dart';

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return LocalStorageRepository();
});

final clientProvider = Provider<Client>((ref) {
  return Client(); // Replace this with your actual client setup
});

final tokenProvider = FutureProvider<String?>((ref) async {
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return await localStorageRepository.getToken();
});
