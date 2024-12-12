import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donor_carousel.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/home_header.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<UserModel>(
                stream:
                    getUserStream(), // اشتراك في التحديثات المباشرة لبيانات المستخدم
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
              ),
            ],
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: const DonorCarousel(),
          ),
        ],
      ),
    );
  }
}
