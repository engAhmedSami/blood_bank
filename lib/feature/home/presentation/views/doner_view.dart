import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/add_doner_request_view_body_bloc_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/manger/add_product_cubit/add_doner_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonerView extends StatelessWidget {
  const DonerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Donation Request',
          style: TextStyles.semiBold24.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => AddDonerRequestCubit(
          getIt.get<DonerRepo>(),
        ),
        child: const AddDonerRequestViewBodyBlocBuilder(),
      ),
    );
  }
}
