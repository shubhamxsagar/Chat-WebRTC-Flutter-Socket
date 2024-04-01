import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/helper/chat_helper.dart';
import 'package:the_haha_guys/models/response/chat_box_models.dart';
import 'package:the_haha_guys/reducer/chat_box_redux.dart';

// class ChatNotifier extends ChangeNotifier {
//   late Future<List<ChatBox>> chatBox;
//   getChatBox() {
//     chatBox = ChatHelper.getChatBox();
//   }
// }

// final chatBoxProvider = FutureProvider<List<ChatBox>>((ref) {
//   return ChatHelper.getChatBox();
// });

// final chatBoxProvider = FutureProvider<List<ChatBox>>((ref) async {
//   final chatBoxData = await ChatHelper.getChatBox();
//   store.dispatch(SetChatBoxAction(chatBoxData));
//   return chatBoxData;
// });
