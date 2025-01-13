import 'dart:developer';

import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_need_request_cubit/add_need_request_cubit.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/custom_need_drawer.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/add_need_request_view_body_bloc_builder.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeedView extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Create a GlobalKey to control the Scaffold's Drawer
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  NeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Assign the GlobalKey to the Scaffold
      drawer: CustomNeedDrawer(userId: userId), // Pass the userId to the drawer
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer(); // Open the drawer
            if (kDebugMode) {
              log('------------- Drawer opened -------------');
            }
          },
          icon: const Icon(
            Icons.list_rounded,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'blood_needed'.tr(context),
          style: TextStyles.semiBold19.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => AddNeederRequestCubit(
          getIt.get<NeederRepo>(),
        ),
        child: const AddNeedRequestViewBodyBlocBuilder(),
      ),
    );
  }
}
