
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> _selectedmessage = {};
  bool _isSelectionMode = false;
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  String senderName = "";
  List<Map<String, dynamic>> inboxChats = [];

  Set<String> get selectedmessage => _selectedmessage;
  bool get isSelectionMode => _isSelectionMode;

  String getOtherUserId(List participants) {
    String uid = _auth.currentUser!.uid;
    return participants.firstWhere((id) => id != uid, orElse: () => '');
  }
  
  ChatProvider() {
    _fetchSenderName();
    messageController.addListener(() {
      isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }

  Future<void> _fetchSenderName() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot customerDoc =
            await _firestore.collection('Customers').doc(user.uid).get();
        if (customerDoc.exists) {
          senderName = customerDoc['name'] ?? "Unknown";
        } else {
          DocumentSnapshot workerDoc =
              await _firestore.collection('Worker').doc(user.uid).get();
          if (workerDoc.exists) {
            senderName = workerDoc['name'] ?? "Unknown";
          } else {
            senderName = "Unknown";
          }
        }
        notifyListeners();
      } else {
        senderName = "Unknown";
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching sender name: $e');
      senderName = "Unknown";
      notifyListeners();
      Fluttertoast.showToast(msg: 'Failed to fetch sender name: $e');
    }
  }

  String getChatId(String userId, String workerId) {
    List<String> ids = [userId, workerId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage(
      String receiverId, String receiverName, String message) async {
    try {
      final currentUser = _auth.currentUser!;
      final currentUserId = currentUser.uid;

      if (senderName.isEmpty || senderName == "Unknown") {
        await _fetchSenderName();
      }

      final chatId = getChatId(currentUserId, receiverId);
      final chatDocRef = _firestore.collection('chats').doc(chatId);

      await chatDocRef.set({
        'participants': [currentUserId, receiverId],
        'senderId': currentUserId,
        'senderName': senderName,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await chatDocRef.collection('messages').add({
        'senderId': currentUserId,
        'senderName': senderName,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController.clear();
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
      Fluttertoast.showToast(msg: 'Failed to send message: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String workerId) {
    String currentUserId = _auth.currentUser!.uid;
    String chatId = getChatId(currentUserId, workerId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedmessage.clear();
    }
    notifyListeners();
  }

  void toggleMessageSelection(String messageId) {
    if (_selectedmessage.contains(messageId)) {
      _selectedmessage.remove(messageId);
    } else {
      _selectedmessage.add(messageId);
    }
    if (_selectedmessage.isEmpty) {
      _isSelectionMode = false;
    }
    notifyListeners();
  }

  Future<void> deleteMessages(String chatId) async {
    try {
      for (String messageId in _selectedmessage) {
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(messageId)
            .delete();
      }
      _selectedmessage.clear();
      _isSelectionMode = false;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete messages: $e');
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

class chatscreen extends StatelessWidget {
  final Map<String, dynamic> workers;

  const chatscreen({super.key, required this.workers});

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;
    String chatId = chatProvider.getChatId(
        chatProvider._auth.currentUser!.uid, workers['uid']);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
         flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Consumer<ChatProvider>(
          builder: (context, chat, _) => chat.isSelectionMode
              ? Text(
                  '${chat.selectedmessage.length} selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: const Color(0xFF00A86B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      workers['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chat, _) {
              return Row(
                children: chat.isSelectionMode
                    ? [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            chat.deleteMessages(chatId);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.push_pin, color: Colors.white),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: 'Pinning not implemented yet');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: chat.toggleSelectionMode,
                        ),
                      ]
                    : [
                        IconButton(
                          icon: const Icon(Icons.videocam, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.white),
                          onPressed: () {},
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (String result) {
                            switch (result) {
                              case 'delete_chat':
                                Fluttertoast.showToast(msg: 'Delete Chat selected');
                                break;
                              case 'mute_notifications':
                                Fluttertoast.showToast(msg: 'Mute Notifications selected');
                                break;
                              case 'Block':
                                Fluttertoast.showToast(msg: "${workers['name']} can't Text or call you");
                                break;
                              case 'settings':
                                Fluttertoast.showToast(msg: 'Settings selected');
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'delete_chat',
                              child: Text('Delete Chat'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Block',
                              child: Text('Block'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'mute_notifications',
                              child: Text('Mute Notifications'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'settings',
                              child: Text('Settings'),
                            ),
                          ],
                        ),
                      ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getMessages(workers['uid']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet...",
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe =
                        message['senderId'] == chatProvider._auth.currentUser?.uid;
                    String messageText = message['text'] ?? '';
                    String messageId = message.id;
                    Timestamp? timestamp = message['timestamp'];
                    String formattedTime = timestamp != null
                        ? DateFormat('hh:mm a').format(timestamp.toDate())
                        : '';

                    return Consumer<ChatProvider>(
                      builder: (context, chat, _) => Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () {
                            chat.toggleSelectionMode();
                            chat.toggleMessageSelection(messageId);
                          },
                          onTap: chat.isSelectionMode
                              ? () => chat.toggleMessageSelection(messageId)
                              : null,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: chat.selectedmessage.contains(messageId)
                                  ? const Color(0xFF00A86B).withOpacity(0.3)
                                  : isMe
                                      ? const Color(0xFF00A86B)
                                      : isDark
                                          ? Colors.grey[700]
                                          : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isMe ? 20 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  messageText,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? Colors.white70 : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatProvider.messageController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                      fillColor: isDark ? Colors.grey[850] : Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, chat, _) {
                    return IconButton(
                      icon: Icon(
                        chat.isTyping ? Icons.send : Icons.mic,
                        color:  Colors.teal,
                      ),
                      onPressed: chat.isTyping
                          ? () {
                              final message = chat.messageController.text.trim();
                              if (message.isNotEmpty) {
                                chat.sendMessage(
                                  workers['uid'],
                                  workers['name'],
                                  message,
                                );
                              }
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
