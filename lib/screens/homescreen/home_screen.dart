import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/provider/shared_prefrenses_provider.dart';
import 'package:the_haha_guys/screens/community_drawer/community_drawer.dart';
import 'package:the_haha_guys/theme/pallete.dart';

final uidProvider = FutureProvider<String>((ref) async {
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return await localStorageRepository.getUid();
});

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({required this.navigationShell, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // IO.Socket? socket;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  // void onPageChanged(int page) {
  //   setState(() {
  //     _page = page;
  //   });
  // }
  void onPageChanged(context, index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<String> uidAsyncValue = ref.watch(uidProvider);

    return uidAsyncValue.when(
        data: (uid) {
          logger.d('UID Home Screen: $uid');
          return Scaffold(
            body: widget.navigationShell,
            drawer: const CommunityListDrawer(),
            // endDrawer: isGuest ? null : const ProfileDrawer(),
            bottomNavigationBar: CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.home),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.chat),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.person),
                  ),
                  label: '',
                ),
              ],
              onTap: (int index) => onPageChanged(context, index),
              currentIndex: widget.navigationShell.currentIndex,
            ),
          );
        },
        error: (error, stackTrace) => Scaffold(
              body: Center(child: Text('Error: $error')),
            ),
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ));
  }
}

// final tokenProvider = FutureProvider<String?>((ref) async {
//   final localStorageRepository = ref.read(localStorageRepositoryProvider);
//   return await localStorageRepository.getToken();
// });

// final responseProvider = FutureProvider<UserModel?>((ref) async {
//   final userController = ref.watch(userContollerProvider);
//   final token = await ref.watch(tokenProvider.future);

//   if (token != null) {
//     return userController.getUser(token);
//   } else {
//     return null;
//   }
// });

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final response = ref.watch(responseProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Screen'),
//       ),
//       body: Center(
//         child: response.when(
//           data: (data) {
//             return Text('${data?.email}, ${data?.name},');
//           },
//           error: (error, stack) {
//             // Handle error
//             return Text('Error fetching token: $error');
//           },
//           loading: () => const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }
