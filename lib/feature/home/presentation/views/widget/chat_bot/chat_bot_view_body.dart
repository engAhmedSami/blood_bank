import 'package:blood_bank/core/utils/app_colors.dart';
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

  final ChatUser _chatGPTUser = ChatUser(
    id: "Dono-r",
    firstName: "Dono-r",
    profileImage: "assets/images/pnglogo.png",
  );

  Gemini? gemini;

  // Add ScrollController to control the scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Gemini.init(
      apiKey: 'AIzaSyChNcCkS_ZV366LoPNKXR6rwtQfU0BIbXE',
      enableDebugging: true,
    );

    gemini = Gemini.instance;
    _fetchCurrentUser();
  }

  // Scroll to the bottom after adding a message
  void _scrollToBottom() {
    // Ensure scroll happens after frame is built
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

  Future<void> _fetchCurrentUser() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
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
          _loadMessages();
        }
      } else {
        debugPrint("No Firebase user found.");
      }
    } catch (error) {
      debugPrint("Error fetching user: $error");
    }
  }

  Future<void> _loadMessages() async {
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

        final messagesSnapshot = await FirebaseFirestore.instance
            .collection('sessions')
            .doc(_currentSessionId)
            .collection('messages')
            .orderBy('createdAt')
            .get();

        setState(() {
          _messages.addAll(messagesSnapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage.fromJson(data);
          }).toList());
        });

        // Scroll to the bottom after loading messages
        _scrollToBottom();
      } else {
        _createNewSession();
      }
    } catch (error) {
      debugPrint("Error loading messages: $error");
    }
  }

  Future<void> _createNewSession() async {
    try {
      final newSession =
          await FirebaseFirestore.instance.collection('sessions').add({
        'userId': _currentUser?.id,
        'createdAt': Timestamp.now(),
      });

      setState(() {
        _currentSessionId = newSession.id;
        _messages.clear();
      });
    } catch (error) {
      debugPrint("Error creating session: $error");
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
    } catch (error) {
      debugPrint("Error saving message: $error");
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

    _saveMessage(userMessage);

    // Scroll to the bottom after the user sends a message
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

      _saveMessage(chatGPTMessage);

      // Scroll to the bottom after adding the response message
      _scrollToBottom();
    } catch (error) {
      debugPrint("Error communicating with Gemini: $error");

      setState(() {
        _messages.add(
          ChatMessage(
            user: _chatGPTUser,
            createdAt: DateTime.now(),
            text: "Sorry, something went wrong. Please try again later.",
          ),
        );
      });

      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentUser == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Attach the controller here
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
          );
  }

  Widget _buildMessage(ChatMessage message) {
    final isCurrentUser = message.user.id == _currentUser?.id;
    final userProfileImage =
        _currentUser?.profileImage ?? 'assets/images/default-avatar.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              backgroundImage: AssetImage(message.user.profileImage ??
                  'assets/images/default-avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 8),
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
          ],
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
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
            CircleAvatar(
              backgroundImage: NetworkImage(userProfileImage),
              radius: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _sendMessage(_messageController.text);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
