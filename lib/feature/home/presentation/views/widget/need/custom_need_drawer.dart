import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/need_tile.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomNeedDrawer extends StatelessWidget {
  final String userId;

  const CustomNeedDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
            ),
            child: Text(
              'my_requests'.tr(context), // Localized title
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // StreamBuilder to fetch and display need requests
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('neederRequest') // Collection for need requests
                .where('uId', isEqualTo: userId) // Filter by user ID
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'no_requests_found'.tr(context), // Localized message
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }

              final requests = snapshot.data!.docs;

              return Column(
                children: requests.map((doc) {
                  final requestData = doc.data() as Map<String, dynamic>;
                  return NeedTile(
                    donationId: doc.id,
                    data: requestData,
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
