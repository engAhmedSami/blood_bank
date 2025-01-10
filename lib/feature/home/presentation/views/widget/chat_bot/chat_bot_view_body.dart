import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart' as intl;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSessionChoiceDialog();
    });
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
    final sessionNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Name Your Session".tr(context)),
        content: TextField(
          controller: sessionNameController,
          decoration:
              InputDecoration(hintText: "Enter session name".tr(context)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel".tr(context)),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Session '$sessionName' created successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  debugPrint("Error creating session: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Failed to create session. Please try again."
                              .tr(context)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Session name cannot be empty!".tr(context)),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: Text("Save".tr(context)),
          ),
        ],
      ),
    );
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
          text: "Sorry, something went wrong. Please try again later."
              .tr(context),
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showSessionList() async {
    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: _currentUser?.id)
        .get();

    final sessions = sessionsSnapshot.docs;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Previous Chats".tr(context),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final sessionName =
                        session['name'] ?? "Session ${index + 1}";
                    final createdAt = session['createdAt']?.toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.chat, color: Colors.blue),
                        ),
                        title: Text(
                          sessionName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: createdAt != null
                            ? Text(
                                "Created on: ${createdAt.toString().split(' ')[0]}",
                                style: const TextStyle(fontSize: 12),
                              )
                            : null,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          setState(() {
                            _currentSessionId = session.id;
                          });
                          Navigator.pop(context);
                          _loadMessages(session.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSessionChoiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose an Action".tr(context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Would you like to start a new session or view previous chats?"
                    .tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _createNewSession();
                      },
                      icon:
                          const Icon(Icons.add, color: AppColors.primaryColor),
                      label: Text("New Session".tr(context)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSessionList();
                      },
                      icon: const Icon(Icons.history,
                          color: AppColors.primaryColor),
                      label: Text("Previous Chats".tr(context)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
      body: Directionality(
        textDirection: TextDirection.ltr, // Set text direction to LTR
        child: Column(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: AssetImage(message.user.profileImage ??
                  'assets/images/default-avatar.png'),
              radius: 20,
            ),
          Expanded(
            child: Padding(
              padding: isCurrentUser
                  ? const EdgeInsets.only(right: 4)
                  : const EdgeInsets.only(left: 4),
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    intl.DateFormat('hh:mm a').format(message.createdAt),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser)
            CircleAvatar(
              backgroundImage: NetworkImage(message.user.profileImage ??
                  'assets/images/default-avatar.png'),
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
                hintText: "Type a message...".tr(context),
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
      title: Text("chat_bot".tr(context), style: TextStyles.bold19),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'new_chat'.tr(context)) {
              _createNewSession();
            } else if (value == 'view_chats'.tr(context)) {
              _showSessionList();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 'new_chat'.tr(context),
                child: Text("Start New Chat".tr(context))),
            PopupMenuItem(
                value: 'view_chats'.tr(context),
                child: Text("View Previous Chats".tr(context))),
          ],
        ),
      ],
    );
  }
}
