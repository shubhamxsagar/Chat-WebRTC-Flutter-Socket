import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_haha_guys/route_constants.dart';
import 'package:the_haha_guys/screens/chatscreen/chatdetail/call_screen.dart';
import 'package:the_haha_guys/screens/chatscreen/chatdetail/chat_detail.dart';
import 'package:the_haha_guys/screens/chatscreen/chatdetail/messages_detail.dart';
import 'package:the_haha_guys/screens/community_drawer/create_community.dart';
import 'package:the_haha_guys/screens/feed_screen/feed_screen.dart';
import 'package:the_haha_guys/screens/homescreen/home_screen.dart';
import 'package:the_haha_guys/screens/loginscreen/login_screen.dart';
import 'package:the_haha_guys/screens/profilescreen/profile_post.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.login,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        name: RouteConstants.createCommunity,
        path: '/create-community',
        builder: (context, state) {
          return const CreateCommunityScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: ((context, state, navigationShell) =>
            HomeScreen(navigationShell: navigationShell)),
        branches: [
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              name: RouteConstants.home,
              path: '/',
              builder: (context, state) {
                return const FeedScreen();
              },
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              name: RouteConstants.chat,
              path: '/chat',
              builder: (context, state) {
                return const ChatDetail();
              },
              routes: [
                GoRoute(
                  name: RouteConstants.chatDetail,
                  path:
                      'chat-detail/:recieverId/:name/:profilePic/:senderId/:conversationId',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: Builder(builder: (context) {
                        return MessagesDetailScreen(
                          recieverId: state.pathParameters['recieverId']!,
                          name: state.pathParameters['name']!,
                          profilePic: state.pathParameters['profilePic']!,
                          senderId: state.pathParameters['senderId']!,
                          conversationId:
                              state.pathParameters['conversationId']!,
                        );
                      }),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: RouteConstants.videoCall,
                      path: 'video-call/:callerId/:calleeId/:offer',
                      pageBuilder: (context, state) {
                        return MaterialPage(child: CallScreen(callerId: state.pathParameters['callerId']!, calleeId: state.pathParameters['calleeId']!, offer: state.pathParameters['offer']!));
                      },)
                  ]
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              name: RouteConstants.profile,
              path: '/profile',
              builder: (context, state) {
                return const ProfilePost();
              },
            ),
          ]),
        ],
      ),
    ],
    redirect: (context, state) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');
      if (token == null && state.matchedLocation == '/') {
        return state.namedLocation(RouteConstants.login);
      }
      return null;
    },
  );
}



// final loggedOutRoute = RouteMap(routes: {
//   '/': (_) => const MaterialPage(child: LoginScreen()),
// });

// final loggedInRoute = RouteMap(routes: {
//   '/': (_) => const MaterialPage(child: HomeScreen()),
//   '/create-community': (_) =>
//       const MaterialPage(child: CreateCommunityScreen()),
//   '/chat-detail/:id/:name/:senderId/:profilePic/:conversationId': (info) {
//     return MaterialPage(
//       child: Builder(builder: (context) {
//         final routeParams = RouteData.of(context).pathParameters;
//         return MessagesDetailScreen(
//             recieverId: routeParams['id'],
//             name: routeParams['name'],
//             profilePic: routeParams['profilePic'],
//             senderId: routeParams['senderId'],
//             conversationId: routeParams['conversationId']);
//       }),
//     );
//   },
// });
