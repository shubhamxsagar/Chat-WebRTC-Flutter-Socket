import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:the_haha_guys/core/constants/hosts.dart';

final socketConnectionProvider =
    ChangeNotifierProvider<SocketContext>((ref) => SocketContext());

// class SocketRepository{
//   final _socketClient = SocketContext.in
// }

class SocketContext extends ChangeNotifier {
  IO.Socket? _socket;
  List<String> _onlineUsers = [];

  // IO.Socket? get socket => _socket;
  List<String> get onlineUsers => _onlineUsers;

  connect(String uid) {
    _socket = IO.io(host, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": {"userId": uid},
    });
    _socket!.connect();

    _socket!.on('getOnlineUsers', (users) {
      setOnlineUsers(users);
    });
  }

  void setOnlineUsers(List<String> users) {
    _onlineUsers = List<String>.from(users);
    notifyListeners();
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.close();
    }
  }
}
