import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/logout_button.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/big_info_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/custom_app_bar_profile.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_switch.dart';
import 'package:blood_bank/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<UserModel>(
                stream: getUserStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CoustomCircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('error_occurred'.tr(context)));
                  }

                  if (!snapshot.hasData) {
                    return Center(
                        child: Text('no_user_data_available'.tr(context)));
                  }

                  final user = snapshot.data!;

                  return CustomProfileAppBar(
                    name: user.name,
                    photoUrl: user.photoUrl,
                    userState: user.userState.tr(context),
                  );
                },
              ),
              const SizedBox(height: 60),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: kHorizintalPadding),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SettingsSwitch(
                      title: 'available_to_donate'.tr(context),
                      keyName: 'available_to_donate',
                    ),
                    SettingsSwitch(
                      title: 'notification'.tr(context),
                      keyName: 'notification',
                    ),
                    SettingsSwitch(
                      title: 'allow_tracking'.tr(context),
                      keyName: 'allow_tracking',
                    ),
                    SettingsItem(
                      title: 'manage_address'.tr(context),
                      icon: Icons.location_on,
                    ),
                    SettingsItem(
                      title: 'language'.tr(context),
                      icon: Icons.language,
                      onTap: () => _showLanguagePicker(context),
                    ),
                    SettingsItem(
                      title: 'contact_details'.tr(context),
                      icon: Icons.arrow_forward_ios,
                    ),
                    const SizedBox(height: 20),
                    LogoutFeature(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 175,
            left: 20,
            right: 20,
            child: StreamBuilder<UserModel>(
              stream: getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('error_occurred'.tr(context)));
                }

                if (!snapshot.hasData) {
                  return Center(
                      child: Text('no_user_data_available'.tr(context)));
                }

                final user = snapshot.data!;
                return BigInfoCard(
                  savedLives: 'lives_saved'.tr(context),
                  bloodGroup:
                      '${user.bloodType.tr(context)} ${'group'.tr(context)}',
                  nextDonationDate: 'next_donation_date'.tr(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'choose_language'.tr(context),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text('english'.tr(context),
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text('arabic'.tr(context),
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('ar');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
