import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'package:blood_bank/feature/auth/presentation/view/signup_view_body_block_consumer.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        getIt.get<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          top: 120,
          leadingIcon: Icons.arrow_back_ios_new_rounded,
          title: 'sign_up'.tr(context),
        ),
        body: const SignupViewBodyBlockConsumer(),
      ),
    );
  }
}
