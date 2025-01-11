import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/custom_donner_drawer.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/add_doner_request_view_body_bloc_builder.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonerView extends StatelessWidget {
  const DonerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Create a GlobalKey to control the Scaffold's Drawer
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.list_rounded,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'donation_request'.tr(context),
          style: TextStyles.semiBold19.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: CustomDonnerDrawer(userId: userId), // Pass userId to CustomDrawer
      body: BlocProvider(
        create: (context) => AddDonerRequestCubit(
          getIt.get<DonerRepo>(),
        ),
        child: const AddDonerRequestViewBodyBlocBuilder(),
      ),
    );
  }
}
