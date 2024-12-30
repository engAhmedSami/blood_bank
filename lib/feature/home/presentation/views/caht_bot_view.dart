import 'package:blood_bank/feature/home/presentation/views/widget/chat_bot/chat_bot_view_body.dart';
import 'package:flutter/material.dart';

class CahtBotView extends StatelessWidget {
  const CahtBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      body: ChatBotViewBody(),
    );
  }
}
