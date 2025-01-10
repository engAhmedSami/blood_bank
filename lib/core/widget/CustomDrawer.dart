import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final String userId; // Accept userId as a parameter

  const CustomDrawer({super.key, required this.userId});

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
          // Fetch and display donations
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('donerRequest')
                .where('uId',
                    isEqualTo: userId) // Use userId to filter donations
                .snapshots(),
            builder: (context, snapshot) {
              // Handle loading, error, and data states
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CoustomCircularProgressIndicator());
              }

              if (snapshot.hasError) {
                // return Center(child: Text('Error: ${snapshot.error}'));
                return CustomDialog(
                  title: 'error_occurred'.tr(context),
                  content: 'error_occurred: ${snapshot.error}'.tr(context),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // return const Center(child: Text('No donations found.'));
                return CustomDialog(
                  title: 'no_donation_requests_available'.tr(context),
                  content: 'no_donation_requests_available'.tr(context),
                );
              }

              final donations = snapshot.data!.docs;

              return Column(
                children: donations.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['name'] ?? 'No Name'),
                    subtitle: Text(
                        'Hospital: ${data['hospitalName'] ?? 'No Hospital'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _handleEditDonation(doc.id);
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _handleDeleteDonation(doc.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _handleDonationTap(doc.id);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Handle donation tap
  void _handleDonationTap(String donationId) {
    // Navigate to donation details or perform other actions
    print('Tapped donation: $donationId');
  }

  // Handle edit donation
  void _handleEditDonation(String donationId) {
    // Implement edit functionality
    print('Edit donation: $donationId');
  }

  // Handle delete donation
  void _handleDeleteDonation(String donationId) {
    // Implement delete functionality
    print('Delete donation: $donationId');
  }
}
