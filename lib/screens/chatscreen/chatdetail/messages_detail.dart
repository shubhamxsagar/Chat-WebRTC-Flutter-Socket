import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_haha_guys/core/common/app_bar.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';
import 'package:the_haha_guys/helper/message_detail_helper.dart';
import 'package:the_haha_guys/helper/send_message_helper.dart';
import 'package:the_haha_guys/models/request/send_message_model.dart';
import 'package:the_haha_guys/models/response/message_list_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:the_haha_guys/route_constants.dart';
import 'package:the_haha_guys/screens/chatscreen/chatdetail/call_screen.dart';

@immutable
class MessagesDetailScreen extends ConsumerStatefulWidget {
  // SocketRepository socketRepository = SocketRepository();
  final String? recieverId;
  final String? name;
  final String? profilePic;
  final String? senderId;
  final String? conversationId;
  const MessagesDetailScreen({
    Key? key,
    // this.socket,
    required this.recieverId,
    required this.name,
    required this.profilePic,
    required this.senderId,
    required this.conversationId,
  }) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MessagesDetailScreen();
}

class _MessagesDetailScreen extends ConsumerState<MessagesDetailScreen> {
  int offset = 1;
  IO.Socket? socket;
  List<MessageDetail> messages = [];
  late Future<List<MessageDetail>>? msgList;
  TextEditingController _messageController = TextEditingController();
  List<String> onlineUsers = [];
  ScrollController _scrollController = ScrollController();
  bool reciever = false;
  dynamic incomingSDPOffer;

  @override
  void initState() {
    logger.f('Receiver ID: ${widget.recieverId}');
    logger.f('Name: ${widget.name}');
    logger.f('Profile Pic: ${widget.profilePic}');
    logger.f('Sender ID: ${widget.senderId}');
    logger.f('Conversation ID: ${widget.conversationId}');

    getMessage(offset);
    connect();
    handleNext();
    super.initState();
  }

  void connect() {
    // var messageNotifier = ref.read(messageDetailRecieve.notifier);
    socket = IO.io(host, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": {'users': widget.senderId},
    });
    socket!.connect();

    socket!.on('connect', (_) {
      logger.e('Connected to server');
      socket!.emit('joinRoom', widget.conversationId);
    });

    socket!.on('newCall', (data) {
      logger.e('newCall: $data');
      if (mounted) {
        setState(() => incomingSDPOffer = data);
      }
    });

    socket!.on('receiveMessage', (data) {
      logger.e('receiveMessage: $data');
      MessageDetail recieveMessage = MessageDetail.fromJson(data);
      if (recieveMessage.senderId != widget.senderId) {
        setState(() {
          messages.insert(0, recieveMessage);
        });
      }
    });

    socket!.on('stopTyping', (data) {
      if (data['senderId'] == widget.recieverId) {
        setState(() {
          reciever = false;
        });
      }
    });
    socket!.on('startTyping', (data) {
      if (data['senderId'] == widget.recieverId) {
        setState(() {
          reciever = true;
        });
      }
    });
  }

  _joinCall({
    required String callerId,
    required String calleeId,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
            callerId: callerId,
            calleeId: calleeId,
            offer: offer,
            onCallEnded: () {
              setState(() {
                incomingSDPOffer = null;
              });
            }),
      ),
    );
  }

  void sendMessage(String message, String receiverId, String senderId) {
    SendMessage model = SendMessage(
      message: message,
      senderId: senderId,
      recieverId: receiverId,
    );

    ref.watch(messageReciever).sendMessage(model).then(

        // SendMessageHelper.sendMessage(model).then(
        (response) {
      var emission = response[2];
      logger.d('emission: $emission');
      socket!.emit('sendMessage', {
        'roomId': widget.conversationId,
        'message': emission,
      });
      var messageDetailMap = response[1];
      var messageDetail = MessageDetail.fromJson(messageDetailMap);
      setState(() {
        _messageController.clear();
        messages.insert(0, messageDetail);
      });
    });
  }

  // void startTyping() {
  //   socket!.emit('startTyping', {
  //     'roomId': widget.conversationId,
  //     'senderId': widget.senderId,
  //     'isTyping': true,
  //   });
  // }

  // void stopTyping() {
  //   socket!.emit('stopTyping', {
  //     'roomId': widget.conversationId,
  //     'senderId': widget.senderId,
  //     'isTyping': false,
  //   });
  // }

  void getMessage(int offset) {
    msgList = ref
        .read(messageDetailRecieve)
        .getMessageDetail(widget.recieverId!, offset);
  }

  void handleNext() {
    _scrollController.addListener(() async {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          logger.t("<<><><loading><><>>");
          if (messages.length >= 12) {
            getMessage(offset++);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    logger.e('Socket Disconnected');
    socket!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final messageDetail = ref.watch(messageDetailRecieve.notifier);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: incomingSDPOffer != null
            ? Positioned(
                child: ListTile(
                  title: Text(
                    "Incoming Call from ${incomingSDPOffer["callerId"]}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call_end),
                        color: Colors.redAccent,
                        onPressed: () {
                          setState(() => incomingSDPOffer = null);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.call),
                        color: Colors.greenAccent,
                        onPressed: () {
                          _joinCall(
                            callerId: incomingSDPOffer["callerId"]!,
                            calleeId: widget.senderId!,
                            offer: incomingSDPOffer["sdpOffer"],
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            : CustomAppBar(
                text: reciever ? 'Typing' : widget.name!,
                actions: [
                  IconButton(
                      onPressed: () {
                        _joinCall(
                          callerId: widget.senderId!,
                          calleeId: widget.recieverId!,
                        );
                        setState(() => incomingSDPOffer = null);
                      },
                      icon: Icon(Icons.videocam)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profilePic!),
                      ),
                      Positioned(
                          right: 3,
                          child: CircleAvatar(
                            // final isOnline = onlineUsers.contains(data.receiverId);
                            radius: 5,
                            backgroundColor:
                                onlineUsers.contains(widget.conversationId)
                                    ? Colors.green
                                    : Colors.grey,
                          ))
                    ]),
                  )
                ],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    child: const Icon(Icons.arrow_back),
                    onTap: () {
                      context.goNamed(RouteConstants.chat);
                    },
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<MessageDetail>>(
                  // future: messageDetail.getMessageDetail(widget.id!),
                  // future: messageDetail.getMessageDetail(widget.recieverId!),
                  future: msgList,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      logger.d('snapshot: ${widget.conversationId}');
                      // final List<MessageDetail> messageDetail = snapshot.data!;
                      final msgList = snapshot.data;
                      messages = messages + msgList!;
                      // Group messages by date
                      Map<String, List<MessageDetail>> groupedMessages = {};
                      for (var message in messages) {
                        DateTime? createdAt = message.createdAt;
                        String date = _formatDate(createdAt!); // Format date
                        groupedMessages
                            .putIfAbsent(date, () => [])
                            .add(message);
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: groupedMessages.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          String date = groupedMessages.keys.toList()[index];
                          logger.w('messages List: $messages');
                          messages = groupedMessages[date] ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  date, // Display date
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  if (messages[index].recieverId ==
                                      widget.recieverId) {
                                    return BubbleSpecialThree(
                                      text: messages[index].message ?? '',
                                      tail: false,
                                      color: Colors.blueGrey[100]!,
                                      textStyle:
                                          const TextStyle(color: Colors.black),
                                    );
                                  } else {
                                    return BubbleSpecialThree(
                                      text: messages[index].message ?? '',
                                      tail: false,
                                      isSender: false,
                                      color:
                                          const Color.fromARGB(255, 67, 66, 66),
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                alignment: Alignment.bottomCenter,
                child: TextField(
                  cursorColor: Colors.white,
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    hintText: 'Type a message',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final message = _messageController.text;
                        if (message.isNotEmpty) {
                          sendMessage(
                              message, widget.recieverId!, widget.senderId!);
                        }
                      },
                    ),
                  ),
                  // onChanged: (value) {
                  //   startTyping();
                  // },
                  // onTapOutside: (details) {
                  //   stopTyping();
                  // },
                  onSubmitted: (_) {
                    final message = _messageController.text;
                    if (message.isNotEmpty) {
                      sendMessage(
                          message, widget.recieverId!, widget.senderId!);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'Today';
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Yesterday';
  } else {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}
