import 'package:blood_bank/core/helper_function/failuer_top_snak_bar.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signin_cubit/signin_cubit.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/forgot_password_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(
        getIt.get<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          top: 120,
          left: 50,
          title: 'Forgot Password'.tr(context),
          leadingIcon: Icons.arrow_back_ios_new_rounded,
        ),
        body: ForgotPasswordViewBodyBlocCunsumer(),
      ),
    );
  }
}

class ForgotPasswordViewBodyBlocCunsumer extends StatelessWidget {
  const ForgotPasswordViewBodyBlocCunsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          succesTopSnackBar(
              context, 'Password reset link sent to ${state.userEntity.email}');
        } else if (state is SigninFailure) {
          failuerTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
            isLoading: state is SigninLoading,
            child: const ForgotPasswordViewBody());
      },
    );
  }
}
