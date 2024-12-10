import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BigInfoCard extends StatelessWidget {
  final String savedLives;
  final String bloodGroup;
  final String nextDonationDate;

  const BigInfoCard({
    super.key,
    required this.savedLives,
    required this.bloodGroup,
    required this.nextDonationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoColumn(title: savedLives, image: Assets.imagesLifesaved),
          InfoColumn(title: bloodGroup, image: Assets.imagesBlood),
          InfoColumn(title: nextDonationDate, image: Assets.imagesLifesaved),
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String image;

  const InfoColumn({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image, height: 30),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
