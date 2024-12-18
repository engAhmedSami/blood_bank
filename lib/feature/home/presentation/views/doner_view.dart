import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/add_user_request.dart';
import 'package:flutter/material.dart';

class DonerView extends StatelessWidget {
  const DonerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Donation Request',
          style: TextStyles.semiBold24.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: DonerRequest(),
    );
  }
}
