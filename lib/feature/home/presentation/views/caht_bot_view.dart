import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/chat_bot/chat_bot_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CahtBotView extends StatelessWidget {
  const CahtBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ChatBotViewBody(),
    );
  }
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
  );
}
