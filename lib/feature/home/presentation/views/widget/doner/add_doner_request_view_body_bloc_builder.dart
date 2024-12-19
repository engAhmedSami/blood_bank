import 'package:blood_bank/core/helper_function/failuer_top_snak_bar.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/add_user_request.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper_function/scccess_top_snak_bar.dart';

class AddDonerRequestViewBodyBlocBuilder extends StatelessWidget {
  const AddDonerRequestViewBodyBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDonerRequestCubit, AddDonerRequestState>(
      listener: (context, state) {
        if (state is AddDonerRequestSuccess) {
          succesTopSnackBar(context, 'Product Added Successfully');
        }
        if (state is AddDonerRequestFailure) {
          failuerTopSnackBar(context, 'Something went wrong ');
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
            isLoading: state is AddDonerRequestLoading,
            child: const DonerRequest());
      },
    );
  }
}
