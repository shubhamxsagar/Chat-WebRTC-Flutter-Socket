// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:routemaster/routemaster.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:the_haha_guys/core/clients/socket_client.dart';
// import 'package:the_haha_guys/core/common/logger.dart';
// import 'package:the_haha_guys/core/constants/constants.dart';
// import 'package:the_haha_guys/core/constants/hosts.dart';
// import 'package:the_haha_guys/helper/chat_helper.dart';
// import 'package:the_haha_guys/helper/message_detail_helper.dart';
// import 'package:the_haha_guys/models/response/chat_box_models.dart';
// import 'package:the_haha_guys/reducer/chat_box_redux.dart';

// @immutable
// class ChatDetail extends ConsumerStatefulWidget {
//   String? uid;
//   ChatDetail({Key? key, required this.uid}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailState();
// }

// class _ChatDetailState extends ConsumerState<ChatDetail>
//     with WidgetsBindingObserver {
//   IO.Socket? socket;
//   SocketContext socketContext = SocketContext();
//   List<String> onlineUsers = [];
//   bool _isDisposed = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//     connect();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//     disconnect();
//     _isDisposed = true; // Update the flag when disposing the widget
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (!_isDisposed) {
//       // Check if the widget is still mounted
//       if (state == AppLifecycleState.resumed) {
//         connect();
//       } else if (state == AppLifecycleState.paused) {
//         disconnect();
//       }
//     }
//   }

//   void connect() {
//     socket = IO.io(host, <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//       "query": {"userId": widget.uid},
//     });
//     socket!.connect();
//     socket!.on("getOnlineUsers", (users) {
//       if (!_isDisposed) { // Check if the widget is still mounted
//         setState(() {
//           onlineUsers = List<String>.from(users); 
//           logger.e('Online Users: $onlineUsers');
//         });
//       }
//     });
//   }
//   void disconnect() {
//     if (socket != null) {
//       socket!.disconnect();
//       socket!.close();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatBoxNotifier = ref.watch(chatBoxProvider.notifier).getChatBox();
//     return Scaffold(
//       body: Consumer(builder: (context, watch, child) {
//         return FutureBuilder<List<ChatBox>>(
//           future: chatBoxNotifier,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               final chatBoxes = snapshot.data ?? [];
//               logger.e('onlineUsers222: $onlineUsers');
//               return ListView.builder(
//                 itemCount: chatBoxes.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final data = chatBoxes[index];
//                   final isOnline = onlineUsers.contains(data.receiverId);
//                   return InkWell(
//                     onTap: () => {},
//                     // {Routemaster.of(context).push('/chat-detail/$id?name=${data?.name}&profilePic=${data?.profilePic}&SenderId=$senderId')},
//                     child: Container(
//                       key: ValueKey(chatBoxes[index].receiverId),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 10,
//                       ),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             padding: const EdgeInsets.all(0),
//                             decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(40)),
//                                     border: Border.all(
//                                       width: 2,
//                                       color:  isOnline
//                                     ? Colors.green // Change indicator color
//                                     : Theme.of(context).primaryColor,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.23),
//                                         spreadRadius: 2,
//                                         blurRadius: 5,
//                                       ),
//                                     ],
//                                   ),
//                                 // : BoxDecoration(
//                                 //     shape: BoxShape.circle,
//                                 //     boxShadow: [
//                                 //       BoxShadow(
//                                 //         color: Colors.grey.withOpacity(0.5),
//                                 //         spreadRadius: 2,
//                                 //         blurRadius: 5,
//                                 //       ),
//                                 //     ],
//                                 //   ),
//                             child: Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 30,
//                                   backgroundImage: NetworkImage(
//                                       data?.profilePic ??
//                                           Constants.loginEmotePath),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.65,
//                             padding: const EdgeInsets.only(
//                               left: 20,
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Row(
//                                       children: <Widget>[
//                                         Text(
//                                           data?.name ?? 'Name',
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     chatBoxes[index].latestMessage ?? '',
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       color: Color.fromARGB(137, 226, 226, 226),
//                                     ),
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         );
//       }),
//     );
//   }
// }

// //     Scaffold(
// //       body: FutureBuilder<List<ChatBox>>(
// //         future: _chatBoxFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else {
// //             List<ChatBox>? chatBoxes = snapshot.data;
// //             return ListView.builder(
// //               itemCount: chatBoxes!.length,
// //               itemBuilder: (BuildContext context, int index) {
// //                 final data = chatBoxes[index].otherMember;
// //                 final profile = data?.profile;
// //                 return GestureDetector(
// //                   onTap: () => {},
// //                   //  Navigator.push(
// //                   //   context,
// //                   //   MaterialPageRoute(
// //                   //     builder: (_) => ChatScreen(
// //                   //       user: chat.sender,
// //                   //     ),
// //                   //   ),
// //                   // ),
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 30,
// //                       vertical: 10,
// //                     ),
// //                     child: Row(
// //                       children: <Widget>[
// //                         Container(
// //                           padding: const EdgeInsets.all(0),
// //                           decoration: data?.name != null
// //                               ? BoxDecoration(
// //                                   borderRadius: const BorderRadius.all(
// //                                       Radius.circular(40)),
// //                                   border: Border.all(
// //                                     width: 2,
// //                                     color: Theme.of(context).primaryColor,
// //                                   ),
// //                                   // shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Colors.grey.withOpacity(0.23),
// //                                       spreadRadius: 2,
// //                                       blurRadius: 5,
// //                                     ),
// //                                   ],
// //                                 )
// //                               : BoxDecoration(
// //                                   shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Colors.grey.withOpacity(0.5),
// //                                       spreadRadius: 2,
// //                                       blurRadius: 5,
// //                                     ),
// //                                   ],
// //                                 ),
// //                           child: CircleAvatar(
// //                             radius: 30,
// //                             backgroundImage: NetworkImage(
// //                                 profile ?? Constants.loginEmotePath),
// //                           ),
// //                         ),
// //                         Container(
// //                           width: MediaQuery.of(context).size.width * 0.65,
// //                           padding: const EdgeInsets.only(
// //                             left: 20,
// //                           ),
// //                           child: Column(
// //                             children: <Widget>[
// //                               Row(
// //                                 mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                 children: <Widget>[
// //                                   Row(
// //                                     children: <Widget>[
// //                                       Text(
// //                                         data?.name ?? 'Name',
// //                                         style: const TextStyle(
// //                                           fontSize: 16,
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                       // chat.sender.isOnline
// //                                       //     ?
// //                                       Container(
// //                                         decoration: BoxDecoration(
// //                                           shape: BoxShape.circle,
// //                                           color: Theme.of(context).primaryColor,
// //                                         ),
// //                                       )
// //                                       // : Container(
// //                                       //     child: null,
// //                                       //   ),
// //                                     ],
// //                                   ),
// //                                   // Text(
// //                                   //   chat.time,
// //                                   //   style: TextStyle(
// //                                   //     fontSize: 11,
// //                                   //     fontWeight: FontWeight.w300,
// //                                   //     color: Colors.black54,
// //                                   //   ),
// //                                   // ),
// //                                 ],
// //                               ),
// //                               const SizedBox(
// //                                 height: 5,
// //                               ),
// //                               Container(
// //                                 alignment: Alignment.topLeft,
// //                                 child: Text(
// //                                   chatBoxes[index].message ?? '',
// //                                   style: const TextStyle(
// //                                     fontSize: 13,
// //                                     color: Color.fromARGB(137, 226, 226, 226),
// //                                   ),
// //                                   maxLines: 2,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
