// import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
// import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
// import 'package:blood_bank/core/utils/page_rout_builder.dart';
// import 'package:blood_bank/feature/auth/presentation/manager/signin_cubit/signin_cubit.dart';
// import 'package:blood_bank/feature/auth/presentation/view/donor_or_need.dart';
// import 'package:blood_bank/feature/auth/presentation/view/widget/login_view_body.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginViewBodyBlocConsumer extends StatelessWidget {
//   const LoginViewBodyBlocConsumer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SigninCubit, SigninState>(
//       listener: (context, state) {
//         if (state is SigninSuccess) {
//           succesTopSnackBar(
//             context,
//             'Signin Successfully',
//           );
//           Navigator.of(context).pushReplacement(
//             buildPageRoute(
//               const DonorOrNeed(),
//             ),
//           );
//         }
//         if (state is SigninFailure) {
//           failuerTopSnackBar(
//             context,
//             state.message,
//           );
//         }
//       },
//       builder: (context, state) {
//         return CustomProgrssHud(
//           isLoading: state is SigninLoading,
//           child: const LoginViewBody(),
//         );
//       },
//     );
//   }
// }

// class UserBlockEdscreen extends StatelessWidget {
//   const UserBlockEdscreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Text('User Blocked'),
//     ));
//   }
// }

import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/UserBlockedScreen.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signin_cubit/signin_cubit.dart';
import 'package:blood_bank/feature/auth/presentation/view/donor_or_need.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/login_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main Login Screen with BlocConsumer to handle different states
class LoginViewBodyBlocConsumer extends StatelessWidget {
  const LoginViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          _handleSigninSuccess(context);
        } else if (state is SigninFailure) {
          _handleSigninFailure(context, state.message);
        } else if (state is SigninBlocked) {
          _handleSigninBlocked(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: CustomProgrssHud(
            isLoading: state is SigninLoading,
            child: const LoginViewBody(),
          ),
        );
      },
    );
  }

  void _handleSigninSuccess(BuildContext context) {
    succesTopSnackBar(
      context,
      'Signed in successfully!'.tr(context),
    );
    Navigator.of(context).pushReplacement(
      buildPageRoute(const DonorOrNeed()),
    );
  }

  void _handleSigninFailure(BuildContext context, String message) {
    failuerTopSnackBar(context, message);
  }

  void _handleSigninBlocked(BuildContext context) {
    Navigator.of(context).pushReplacement(
      buildPageRoute(const UserBlockedScreen()),
    );
  }
}
