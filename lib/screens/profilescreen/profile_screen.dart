import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:the_haha_guys/screens/profilescreen/profile_post.dart';
import 'package:the_haha_guys/screens/profilescreen/profile_text.dart';
import 'package:the_haha_guys/screens/profilescreen/profile_video.dart';
import 'package:the_haha_guys/view_models/auth_view_model.dart';

class UserProfileScreen extends ConsumerWidget {
  // final String uid;
  const UserProfileScreen({
    super.key,
    // required this.uid,
  });

  final List<Widget> tabs = const [
    Tab(
      icon: Icon(
        Icons.post_add,
        color: Colors.grey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.text_format,
        color: Colors.grey,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.video_collection,
        color: Colors.grey,
      ),
    ),
  ];

  // final List<Widget> tabViews = const [
  //   Expanded(
  //     child: ProfilePost(),
  //   ),
  //   Expanded(
  //     child: ProfileText(),
  //   ),
  //   Expanded(
  //     child: ProfileVideo(),
  //   ),
  // ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOut = ref.read(authRepositoryProvider).signOut;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('365',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    SizedBox(height: 2),
                    Text('Following', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '22.4k',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text('Followers', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Shubham Sagar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        signOut();
                        Routemaster.of(context).push('/');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Set the color of the border
                          width: 1.0, // Set the width of the border
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Community',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              tabs: tabs,
            ),
            const SizedBox(
                height: 1000,
                child: TabBarView(children: [
                  ProfilePost(),
                  ProfileText(),
                  ProfileVideo(),
                ]))
          ],
        ),
      )),
    );
  }
}
