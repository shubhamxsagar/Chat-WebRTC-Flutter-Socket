import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:the_haha_guys/core/clients/singalling_service.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/constants.dart';
import 'package:the_haha_guys/core/constants/hosts.dart';
import 'package:the_haha_guys/helper/meeting_api_helper.dart';
import 'package:the_haha_guys/models/response/chat_box_models.dart';
import 'package:the_haha_guys/provider/shared_prefrenses_provider.dart';
import 'package:the_haha_guys/reducer/chat_box_redux.dart';
import 'package:the_haha_guys/route_constants.dart';
import 'package:the_haha_guys/screens/chatscreen/chatdetail/call_screen.dart';
import 'package:the_haha_guys/screens/homescreen/home_screen.dart';

@immutable
class ChatDetail extends ConsumerStatefulWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailState();
}

class _ChatDetailState extends ConsumerState<ChatDetail>
    with WidgetsBindingObserver {
  IO.Socket? socket;
  List<String> onlineUsers = [];
  dynamic incomingSDPOffer;
  String selfCallerID = '';
  List<String> videoCall = [];
  bool _isDisposed = false;
  String? usersId;

  Future<String> getToken() async {
    final localStorageRepository = ref.read(localStorageRepositoryProvider);
    final uid = await localStorageRepository.getUid();
    return uid;
  }

  @override
  void initState() {
    // super.didChangeDependencies();
    // connect();
    // WidgetsBinding.instance.addObserver(this);

    super.initState();
    // SignallingService.instance.init(
    //   websocketUrl: host,
    //   selfCallerID: selfCallerID,
    // );
  }

  void connect() async {
    String uid = await getToken();
    logger.e('UID in Chat Detail: $getToken()');
    socket = IO.io(host, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": {"users": uid}
    });
    socket!.connect();
    socket!.on("getOnlineUsers", (users) {
      if (!_isDisposed) {
        setState(() {
          onlineUsers = List<String>.from(users);
          logger.e('Online Users: $onlineUsers');
        });
      }
    });
  }

  // void connect() {
  //   logger.t('selfCallerId:');
  //   socket = IO.io(host, <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoConnect": false,
  //     // "query": {"callerId": selfCallerId}
  //   });
  //   socket!.connect();
  // socket!.onConnect((data) {
  //   logger.e("Socket connected !!");
  // });
  // socket!.onConnectError((data) {
  //   logger.e("Connect Error $data");
  // });
  // socket!.on("newCall", (data) {
  //   if (mounted) {
  //     setState(() => incomingSDPOffer = data);
  //   }
  // });
  // }

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
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    _isDisposed = true; // Update the flag when disposing the widget
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_isDisposed) {
      // Check if the widget is still mounted
      if (state == AppLifecycleState.resumed) {
        connect();
      } else if (state == AppLifecycleState.paused) {
        disconnect();
      }
    }
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ref.read(localStorageRepositoryProvider).getUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String uid = snapshot.data!;
          return StoreProvider<List<ChatBox>>(
            store: store,
            child: Scaffold(
              body: StoreConnector<List<ChatBox>, List<ChatBox>>(
                converter: (store) => store.state,
                builder: (context, chatBoxes) {
                  if (chatBoxes.isEmpty) {
                    logger.e('UID in Chat Detail: $uid');
                    fetchChatBoxActionDispatcher(StoreProvider.of(context));
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: chatBoxes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = chatBoxes[index];
                        final isOnline =
                            onlineUsers.contains(data.participants!.id);
                        return InkWell(
                          onTap: () => {
                            context.pushNamed(
                              RouteConstants.chatDetail,
                              pathParameters: {
                                "recieverId": data.participants!.id!,
                                "name": data.participants!.name!,
                                "profilePic": data.participants!.profilePic!,
                                "senderId": uid, // Using the retrieved uid
                                "conversationId": data.id!,
                              },
                            )
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration:
                                          data.participants!.name != null
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(40)),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: isOnline
                                                        ? Colors.green
                                                        : Colors.grey,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: isOnline
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                )
                                              : BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: isOnline
                                                          ? Colors.green
                                                          : Colors.grey
                                                              .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                data.participants!.profilePic ??
                                                    Constants.loginEmotePath),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              data.participants!.name ?? 'Name',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              chatBoxes[index].latestMessage ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromARGB(
                                                    137, 226, 226, 226),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}
