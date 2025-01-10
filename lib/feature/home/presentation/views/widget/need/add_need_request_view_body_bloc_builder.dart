import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_need_request_cubit/add_need_request_cubit.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/add_need_request.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper_function/scccess_top_snak_bar.dart';

class AddNeedRequestViewBodyBlocBuilder extends StatelessWidget {
  const AddNeedRequestViewBodyBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNeederRequestCubit, AddNeedRequestState>(
      listener: (context, state) {
        if (state is AddDonerRequestSuccess) {
          successTopSnackBar(
            context,
            'product_added_successfully'.tr(context),
          );
        }
        if (state is AddDonerRequestFailure) {
          failureTopSnackBar(context, 'something_went_wrong'.tr(context));
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
            isLoading: state is AddDonerRequestLoading,
            child: const NeedRequest());
      },
    );
  }
}
