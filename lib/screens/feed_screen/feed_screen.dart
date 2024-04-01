import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/helper/message_detail_helper.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

    void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final messageDetail = ref.watch(messageDetailProvider('65bb7106ddddc595c4f55e70'));
    return Scaffold(
      appBar: AppBar(
              title: const Text('TheHaHaGuys'),
              centerTitle: false,
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => displayDrawer(context),
                );
              }),
              actions: [
                IconButton(
                  onPressed: () {
                    // showSearch(context: context, delegate: SearchCommunityDelegate(ref));
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    // Routemaster.of(context).push('/add-post');
                  },
                  icon: const Icon(Icons.add),
                ),
                Builder(builder: (context) {
                  return IconButton(
                    icon: const CircleAvatar(
                        // backgroundImage: NetworkImage(user.profilePic),
                        // backgroundImage: NetworkImage(Constants.loginEmotePath),
                        ),
                    onPressed: () => displayEndDrawer(context),
                  );
                }),
              ],
            ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ref.read(messageDetailRecieve.notifier).getMessageDetail('65bb7106ddddc595c4f55e70');
          },
          child: const Text('Get Message Detail'),
        ),
      ),
      //  messageDetail.when(
      //   data: (messageDetail) {
      //     return ListView.builder(
      //       itemCount: messageDetail.length,
      //       itemBuilder: (context, index) {
      //         logger.d(messageDetail[index].message);
      //         return ListTile(
      //           title: Text(messageDetail[index].message.toString()),
      //         );
      //       },
      //     );
      //   },
      //   loading: () => CircularProgressIndicator(),
      //   error: (error, stackTrace) => Text('Error: $error'),
      // ),
    );
  }
}
