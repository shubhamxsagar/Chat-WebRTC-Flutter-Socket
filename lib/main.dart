import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/provider/shared_prefrenses_provider.dart';
import 'package:the_haha_guys/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final tokenProvider = FutureProvider<String>((ref) async {
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return await localStorageRepository.getToken();
});

final myAppRouter = MyAppRouter();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final AsyncValue<String> tokenAsync = ref.watch(tokenProvider);
    // final data = ref.watch(userProvider);
    return MaterialApp.router(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
            indicatorColor: Colors.blueGrey),
        themeMode: ThemeMode.dark,
        routerConfig: myAppRouter.router,
        debugShowCheckedModeBanner: false,
    );
  }
}