import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'package:blood_bank/feature/auth/presentation/view/verfied_email_view.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/signup_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupViewBodyBlockConsumer extends StatelessWidget {
  const SignupViewBodyBlockConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          successTopSnackBar(
            context,
            'account_created_successfully'.tr(context),
          );
        }
        Navigator.of(context).pushReplacement(
          buildPageRoute(
            const VerfiedEmailView(),
          ),
        );

        if (state is SignupFailure) {
          failureTopSnackBar(
            context,
            state.message,
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoding ? true : false,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
