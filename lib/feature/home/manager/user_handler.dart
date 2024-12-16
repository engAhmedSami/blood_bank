import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/home_header.dart';
import 'package:flutter/material.dart';

class UserHandler extends StatelessWidget {
  const UserHandler({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: getUserStream(), // اشتراك في التحديثات المباشرة لبيانات المستخدم
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        }

        final user = snapshot.data!;

        return HomeHeader(
          name: user.name,
          photoUrl: user.photoUrl,
          userState: user.userState,
          bloodType: user.bloodType,
        );
      },
    );
  }
}
