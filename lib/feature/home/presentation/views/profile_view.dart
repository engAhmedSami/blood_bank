import 'package:blood_bank/constants.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:restart_app/restart_app.dart'; // Import the restart_app package

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final shorebirdUpdater = ShorebirdUpdater();
  bool _isCheckingForUpdates = false;
  UpdateTrack currentTrack = UpdateTrack.stable;

  Future<void> _checkForUpdate() async {
    if (_isCheckingForUpdates) return;

    try {
      setState(() => _isCheckingForUpdates = true);
      final status = await shorebirdUpdater.checkForUpdate(track: currentTrack);
      if (!mounted) return;

      switch (status) {
        case UpdateStatus.upToDate:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('up_to_date'.tr(context))),
          );
        case UpdateStatus.outdated:
          _showUpdateDialog(context, shorebirdUpdater);
        case UpdateStatus.restartRequired:
          _showRestartSnackBar(context); // Show a SnackBar to restart the app
        case UpdateStatus.unavailable:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('update_unavailable'.tr(context))),
          );
      }
    } catch (error) {
      debugPrint('Error checking for update: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_checking_for_update'.tr(context))),
      );
    } finally {
      setState(() => _isCheckingForUpdates = false);
    }
  }

  Future<void> _downloadUpdate(ShorebirdUpdater updater) async {
    try {
      await updater.update(track: currentTrack);
      if (!mounted) return;

      // Show a SnackBar to inform the user that the update is downloaded
      _showRestartSnackBar(context);
    } on UpdateException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed: ${e.message}'.tr(context))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed: ${e.toString()}'.tr(context))),
      );
    }
  }

  void _showUpdateDialog(BuildContext context, ShorebirdUpdater updater) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('update_available'.tr(context)),
          content: Text('update_available_message'.tr(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('later'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _downloadUpdate(updater);
              },
              child: Text('update_now'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  void _showRestartSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('update_downloaded_restart'.tr(context)),
        action: SnackBarAction(
          label: 'Restart',
          onPressed: () {
            Restart.restartApp(); // Restart the app
          },
        ),
        duration:
            const Duration(seconds: 10), // Keep the SnackBar visible longer
      ),
    );
  }

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
                      title: 'Check for updates'.tr(context),
                      icon: Icons.arrow_forward_ios,
                      onTap: _checkForUpdate,
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
