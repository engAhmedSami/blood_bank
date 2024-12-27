import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) {
      return const Center(child: Text('No user is logged in'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('donerRequest')
          .where('uId', isEqualTo: currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CoustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final requests = snapshot.data?.docs ?? [];

        String formattedNextDonationDate = 'next_donation_date'.tr(context);
        if (requests.isNotEmpty) {
          final nextDonationTimestamp = requests[0]['nextDonationDate'];

          if (nextDonationTimestamp != null &&
              nextDonationTimestamp is Timestamp) {
            DateTime nextDonationDateTime = nextDonationTimestamp.toDate();
            formattedNextDonationDate =
                DateFormat('yyyy-MM-dd').format(nextDonationDateTime);
          }
        }
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
              InfoColumn(
                title: formattedNextDonationDate,
                image: Assets.imagesNextdonation,
              ),
            ],
          ),
        );
      },
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
        Text(title, textAlign: TextAlign.center, style: TextStyles.semiBold13),
      ],
    );
  }
}
