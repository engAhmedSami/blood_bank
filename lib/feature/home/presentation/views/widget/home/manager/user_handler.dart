import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/home_header.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class UserHandler extends StatelessWidget {
  const UserHandler({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<UserModel>(
          stream: getUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CoustomCircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return CustomDialog(
                title: 'error_occurred'.tr(context),
                content: 'error_occurred: ${snapshot.error}'.tr(context),
              );
            }

            if (!snapshot.hasData) {
              return Center(child: Text('no_user_data_available'.tr(context)));
            }

            final user = snapshot.data!;

            return HomeHeader(
              name: user.name,
              photoUrl: user.photoUrl,
              userState: user.userState.tr(context),
              bloodType: user.bloodType.tr(context),
            );
          },
        ),
      ],
    );
  }
}
