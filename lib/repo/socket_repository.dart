// import 'package:socket_io_client/socket_io_client.dart';
// import 'package:the_haha_guys/core/clients/socket_client.dart';
// import 'package:the_haha_guys/core/common/logger.dart';
// import 'package:the_haha_guys/models/response/message_list_model.dart';

// class SocketRepository {
//   final _socketClient = SocketClient.instance.socket!;
//   Socket get socketClient => _socketClient;

//   void joinRoom(String documentId) {
//     logger.f("socket connected :$documentId");
//     _socketClient.emit('join', documentId);
//   }

//   void typing(bool status) {
//     // _socketClient.emit('typing', status);
//     _socketClient.on('typing', (data) {
//       status = true;
//     });
//   }

//   void stopTyping(bool status) {
//     // _socketClient.emit('typing', status);
//     _socketClient.on('stop typing', (data) {
//       status = false;
//     });
//   }

//   void onlineUser(List<String> ref) {
//     // _socketClient.emit('online-users', data);
//     _socketClient.on('online-users', (data) {
//       ref.replaceRange(0, ref.length, [data]);
//     });
//   }

//   void messageRecieved(String id, String userId, List<MessageDetail> message) {
//     sendStopTypingEvent(id);
//     _socketClient.on('message recieved', (data) {
//       MessageDetail recieveMessage = MessageDetail.fromJson(data);

//       if (recieveMessage.senderId!.id != userId) {
//         // setState(() {
//         message.insert(0, recieveMessage);
//         // });
//       }
//     });
//   }

//   void sendMessage(String id, String message, String receiverId) {
//     // SendMessage model = SendMessage(
//     //   message: message,
//     //   receiverId: receiverId,
//     // );
//     // SendMessageHelper.sendMessage(model.message, model.receiverId)
//     //     .then((response) {
//     //   var emission = response;
//     //   _socketClient.emit('new message', emission);
//     //   sendStopTypingEvent(id);
//     //   // messages.insert(0, response[1]);
//     // });
//     _socketClient.emit('message', {
//       'message': message,
//       'receiverId': receiverId,
//     });
//   }

//   // void newMessage() {
//   //   _socketClient.emit(
//   //     'new message',
//   //   );
//   // }

//   // void sendMessage(String message, String senderId, String receiverId) {
//   //   logger.f("message socket :$message");
//   //   _socketClient.emit('message',
//   //       {'message': message, 'SenderId': senderId, 'ReceiverId': receiverId});
//   // }

//   // void listenForMessages(Function(dynamic) onMessageReceived) {
//   //   _socketClient.on('new-message', (data) {
//   //     onMessageReceived(data);
//   //   });
//   // }

//   void sendTypingEvent(String status) {
//     _socketClient.emit('typing', status);
//   }

//   void sendStopTypingEvent(String status) {
//     _socketClient.emit('stop typing', status);
//   }

//   void joinChat(String id) {
//     _socketClient.emit('join chat', id);
//   }
// }
