import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/user_handler.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/blood_needed.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/custom_card_items.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donor_carousel.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const UserHandler(),
          const Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: DonorCarousel(),
          ),
          const Positioned(
            top: 290,
            left: 0,
            right: 0,
            child: CustomCardItems(),
          ),
          Positioned(
            top: 405,
            left: 0,
            right: 0,
            child: BloodNeededWidget(),
          ),
        ],
      ),
    );
  }
}
