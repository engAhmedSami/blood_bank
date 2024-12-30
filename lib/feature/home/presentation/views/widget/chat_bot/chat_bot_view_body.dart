import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();

    // Initialize OpenAI with your API key
    OpenAI.apiKey =
        "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";

    _fetchCurrentUser();
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

    try {
      final response = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: List.empty(),
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final chatGPTResponse = response.choices.first.message.content.toString();

      final chatGPTMessage = ChatMessage(
        user: _chatGPTUser,
        createdAt: DateTime.now(),
        text: chatGPTResponse,
      );

      setState(() {
        _messages.add(chatGPTMessage);
      });

      _saveMessage(chatGPTMessage);
    } catch (error) {
      debugPrint("Error communicating with ChatGPT: $error");

      setState(() {
        _messages.add(
          ChatMessage(
            user: _chatGPTUser,
            createdAt: DateTime.now(),
            text: "Sorry, something went wrong. Please try again later.",
          ),
        );
      });
    }
  }

  @override
  void dispose() {
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
              // TextButton(
              //   onPressed: _createNewSession,
              //   child: const Text("New Session"),
              // ),
            ],
          );
  }

  Widget _buildMessage(ChatMessage message) {
    final isCurrentUser = message.user.id == _currentUser?.id;
    final userProfileImage = _currentUser?.profileImage ??
        'assets/images/default-avatar.png'; // Fallback if no image is available

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            // Display profile image first, then the message
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
            // Display profile image after the message for current user
            CircleAvatar(
              backgroundImage:
                  NetworkImage(userProfileImage), // Ensure this URL works
              radius: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: _messageController,
              hintText: "Type a message...",
              textInputType: TextInputType.text,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_sharp),
            onPressed: () {
              _sendMessage(_messageController.text);
            },
          ),
        ],
      ),
    );
  }
}
