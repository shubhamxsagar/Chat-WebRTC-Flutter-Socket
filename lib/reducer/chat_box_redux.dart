import 'package:redux/redux.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/helper/chat_helper.dart';
import 'package:the_haha_guys/models/response/chat_box_models.dart';

enum ChatBoxAction { fetchChatBox }

class FetchChatBoxAction {}

void fetchChatBoxActionDispatcher(Store<List<ChatBox>> store) {
  ChatHelper.getChatBox().then((chatBoxData) {
    store.dispatch(SetChatBoxAction(chatBoxData));
  }).catchError((error) {
    logger.d("Error fetching chat box data: $error");
  });
}

// Action to set chat box data
class SetChatBoxAction {
  final List<ChatBox> chatBoxData;
  SetChatBoxAction(this.chatBoxData);
}

// Define reducer
List<ChatBox> chatBoxReducer(List<ChatBox> state, dynamic action) {
  if (action is SetChatBoxAction) {
    return action.chatBoxData;
  }
  return state;
}

// Initialize store
final Store<List<ChatBox>> store = Store<List<ChatBox>>(
  chatBoxReducer,
  initialState: [],
);

void initializeStore() {
  fetchChatBoxActionDispatcher(store);
}

// class ReduxSetup extends StatelessWidget {
//   final Widget child;

//   ReduxSetup({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     initializeStore();

//     return StoreProvider<List<ChatBox>>(
//       store: store,
//       child: const MaterialApp(
//         title: 'Chat Detail',
//         home: ChatDetail(),
//       ),
//     );
//   }
// }
