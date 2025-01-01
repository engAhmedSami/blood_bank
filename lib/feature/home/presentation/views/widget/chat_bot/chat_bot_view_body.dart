import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBotViewBody extends StatefulWidget {
  const ChatBotViewBody({super.key});

  @override
  ChatBotViewBodyState createState() => ChatBotViewBodyState();
}

class ChatBotViewBodyState extends State<ChatBotViewBody> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  ChatUser? _currentUser;
  String? _currentSessionId;
  Gemini? gemini;

  final ChatUser _chatGPTUser = ChatUser(
    id: "Dono-r",
    firstName: "Dono-r",
    profileImage: "assets/images/pnglogo.png",
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _fetchCurrentUser();
  }

  void _initializeGemini() {
    Gemini.init(
      apiKey: 'AIzaSyChNcCkS_ZV366LoPNKXR6rwtQfU0BIbXE',
      enableDebugging: true,
    );
    gemini = Gemini.instance;
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _currentUser = ChatUser(
              id: firebaseUser.uid,
              firstName: userData['name'] ?? "You",
              profileImage:
                  userData['photoUrl'] ?? "assets/images/default-avatar.png",
            );
          });
          _loadLastSession();
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> _loadLastSession() async {
    try {
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('userId', isEqualTo: _currentUser?.id)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (sessionSnapshot.docs.isNotEmpty) {
        final sessionData = sessionSnapshot.docs.first;
        _currentSessionId = sessionData.id;
        await _loadMessages(_currentSessionId!);
      } else {
        debugPrint("No sessions found. Create a new session if needed.");
      }
    } catch (e) {
      debugPrint("Error loading session: $e");
    }
  }

  Future<void> _loadMessages(String sessionId) async {
    try {
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .collection('messages')
          .orderBy('createdAt')
          .get();

      setState(() {
        _messages.clear();
        _messages.addAll(messagesSnapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage.fromJson(data);
        }).toList());
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error loading messages: $e");
    }
  }

  Future<void> _createNewSession() async {
    if (_messages.isNotEmpty) {
      final sessionNameController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Name Your Session"),
          content: TextField(
            controller: sessionNameController,
            decoration: const InputDecoration(hintText: "Enter session name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final sessionName = sessionNameController.text.trim();
                if (sessionName.isNotEmpty) {
                  try {
                    final newSession = await FirebaseFirestore.instance
                        .collection('sessions')
                        .add({
                      'userId': _currentUser?.id,
                      'name': sessionName,
                      'createdAt': Timestamp.now(),
                    });

                    setState(() {
                      _currentSessionId = newSession.id;
                      _messages.clear();
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    debugPrint("Error creating session: $e");
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    } else {
      debugPrint("Cannot create a new session. No messages to save.");
    }
  }

  Future<void> _saveMessage(ChatMessage message) async {
    if (_currentSessionId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('sessions')
          .doc(_currentSessionId)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      debugPrint("Error saving message: $e");
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _currentUser == null) return;

    final userMessage = ChatMessage(
      user: _currentUser!,
      createdAt: DateTime.now(),
      text: text,
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
    });

    await _saveMessage(userMessage);

    _scrollToBottom();

    try {
      final response = await gemini?.chat([
        Content(
          parts: [Part.text(text)],
          role: 'user',
        ),
      ]);

      final chatGPTMessage = ChatMessage(
        user: _chatGPTUser,
        createdAt: DateTime.now(),
        text: response?.output ?? "No response from Gemini",
      );

      setState(() {
        _messages.add(chatGPTMessage);
      });

      await _saveMessage(chatGPTMessage);

      _scrollToBottom();
    } catch (e) {
      debugPrint("Error communicating with Gemini: $e");
      setState(() {
        _messages.add(ChatMessage(
          user: _chatGPTUser,
          createdAt: DateTime.now(),
          text: "Sorry, something went wrong. Please try again later.",
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSessionList() async {
    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: _currentUser?.id)
        .get();

    final sessions = sessionsSnapshot.docs;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              title: Text(
                  session['name'] ?? "Session ${session.id.substring(0, 6)}"),
              onTap: () {
                setState(() {
                  _currentSessionId = session.id;
                });
                Navigator.pop(context);
                _loadMessages(session.id);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              reverse: false,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isCurrentUser = message.user.id == _currentUser?.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // عرض صورة المستخدم (على اليسار للمستخدم الآخر وعلى اليمين للمستخدم الحالي)
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: AssetImage(
                message.user.profileImage ?? 'assets/images/default-avatar.png',
              ),
              radius: 20,
            ),
          const SizedBox(width: 8),

          // عرض النص في مربع مع تزيين مناسب
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // عرض صورة المستخدم (على اليمين للمستخدم الحالي)
          if (isCurrentUser)
            CircleAvatar(
              backgroundImage: NetworkImage(
                message.user.profileImage ?? 'assets/images/default-avatar.png',
              ),
              radius: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _sendMessage(_messageController.text),
            icon: const Icon(Icons.send_sharp),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "chat_bot".tr(context),
        style: TextStyles.bold19,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'new_chat') {
              _createNewSession();
            } else if (value == 'view_chats') {
              _showSessionList();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'new_chat',
              child: Text("Start New Chat"),
            ),
            const PopupMenuItem(
              value: 'view_chats',
              child: Text("View Previous Chats"),
            ),
          ],
        ),
      ],
    );
  }
}
