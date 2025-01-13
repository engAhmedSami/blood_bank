import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/donation_tile.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomDonnerDrawer extends StatelessWidget {
  final String userId;

  const CustomDonnerDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
            ),
            child: Text(
              'my_donations'.tr(context),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('donerRequest')
                .where('uId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No donations found.'));
              }

              final donations = snapshot.data!.docs;

              return Column(
                children: donations.map((doc) {
                  // ignore: non_constant_identifier_names
                  final DonationData = doc.data() as Map<String, dynamic>;
                  return DonationTile(
                    donationId: doc.id,
                    data: DonationData,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
