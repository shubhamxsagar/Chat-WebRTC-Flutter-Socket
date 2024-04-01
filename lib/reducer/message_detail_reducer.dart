// import 'package:redux/redux.dart';
// import 'package:the_haha_guys/core/common/logger.dart';
// import 'package:the_haha_guys/helper/chat_helper.dart';
// import 'package:the_haha_guys/helper/message_detail_helper.dart';
// import 'package:the_haha_guys/models/response/chat_box_models.dart';
// import 'package:the_haha_guys/models/response/message_list_model.dart';

// enum MessageDetailAction { fetchMessageDetail }

// class FetchMessageDetailAction {}

// void fetchMessageDetailActionDispatcher(Store<List<MessageDetail>> store) {
//   MessageDetailHelper.getMessageDetail().then((messageDetail) {
//     store.dispatch(MessageDetailBoxAction(messageDetail));
//   }).catchError((error) {
//     logger.d("Error fetching chat box data: $error");
//   });
// }

// // Action to set chat box data
// class MessageDetailBoxAction {
//   final List<MessageDetail> messageDetailData;
//   MessageDetailBoxAction(this.messageDetailData);
// }

// // Define reducer
// List<MessageDetail> messageDetailReducer(List<MessageDetail> state, dynamic action) {
//   if (action is MessageDetailBoxAction) {
//     return action.messageDetailData;
//   }
//   return state;
// }

// // Initialize store
// final Store<List<MessageDetail>> store2 = Store<List<MessageDetail>>(
//   messageDetailReducer,
//   initialState: [],
// );

// void initializeStore() {
//   fetchMessageDetailActionDispatcher(store2);
// }

// // class ReduxSetup extends StatelessWidget {
// //   final Widget child;

// //   ReduxSetup({required this.child});

// //   @override
// //   Widget build(BuildContext context) {
// //     initializeStore();

// //     return StoreProvider<List<ChatBox>>(
// //       store: store,
// //       child: const MaterialApp(
// //         title: 'Chat Detail',
// //         home: ChatDetail(),
// //       ),
// //     );
// //   }
// // }
