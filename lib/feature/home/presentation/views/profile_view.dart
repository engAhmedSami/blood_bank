import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/big_info_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/custom_app_bar_profile.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_switch.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الكستم أب بار
          Column(
            children: [
              CustomProfileHeader(
                userName: "Selena Ahmed",
                userId: "915470",
                profileImageUrl:
                    "https://lh3.googleusercontent.com/a/ACg8ocKEAPK5NiXvzXYu3jHIyweeZUnkRC28xlEsybxNbKWTW9i-y1A=s96-c",
                onBackPressed: () {},
                onEditPressed: () {},
              ),
              SizedBox(
                height: 60,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: kHorizintalPadding),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    SettingsSwitch(title: 'Available To Donate', value: true),
                    SettingsSwitch(title: 'Notification', value: true),
                    SettingsSwitch(title: 'Allow Tracking', value: true),
                    SettingsItem(title: 'Manage Address'),
                    SettingsItem(title: 'History'),
                    SettingsItem(title: 'Contact Details'),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.primaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: 175,
            left: 20,
            right: 20,
            child: const BigInfoCard(
              savedLives: '3 life saved',
              bloodGroup: 'A+ Group',
              nextDonationDate: 'Next Donation',
            ),
          ),
        ],
      ),
    );
  }
}
