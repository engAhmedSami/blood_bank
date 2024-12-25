import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/blood_request_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

class BloodRequest extends StatelessWidget {
  const BloodRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('neederRequest').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CoustomCircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data?.docs ?? [];
          if (requests.isEmpty) {
            return CoustomDialog(
              title: 'thanks for your contribution',
              content: 'No requests available at the moment.',
            );

            // const Center(
            //     child: Text('No requests available at the moment.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data();
              return BloodRequestCard(
                request: request,
                onAccept: () {
                  successTopSnackBar(context, 'Request Accepted');
                },
                onDecline: () {
                  failureTopSnackBar(context, 'Request Declined');
                },
              );
            },
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Blood Requests",
        style: TextStyles.semiBold19,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            Assets.imagesNotifcationTwo,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
