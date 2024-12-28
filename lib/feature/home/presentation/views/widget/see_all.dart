import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({
    super.key,
    required this.requests,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index].data();
                return ListTile(
                  leading: StreamBuilder<UserModel>(
                    stream: getUserStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CoustomCircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('error: ${snapshot.error}'.tr(context)));
                      }

                      if (!snapshot.hasData) {
                        return Center(
                            child: Text('no_user_data_available'.tr(context)));
                      }

                      final user = snapshot.data!;

                      return CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoUrl ?? ''),
                      );
                    },
                  ),
                  title: Text(request['name'] ?? 'No Name'),
                  subtitle: _buildSubtitle(request, context),
                  trailing: _buildTrailing(request, context),
                );
              },
            );
          },
        );
      },
      child: Text(
        'see_all'.tr(context), // Use .tr(context) to translate
        style: TextStyles.semiBold14.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildSubtitle(Map<String, dynamic> request, BuildContext context) {
    return Text(
      '${'blood_types'.tr(context)}: ${request['bloodType'].toString().tr(context)}', // Translated string
    );
  }

  Widget _buildTrailing(Map<String, dynamic> request, BuildContext context) {
    return Text('${request['distance'] ?? '0'} ${'km'.tr(context)}');
  }
}
