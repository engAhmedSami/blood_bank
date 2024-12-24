import 'package:blood_bank/core/utils/app_text_style.dart';
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      request['photoUrl'] ??
                          'https://i.stack.imgur.com/l60Hf.png',
                    ),
                  ),
                  title: Text(request['name'] ?? 'No Name'),
                  subtitle: _buildSubtitle(request, context),
                  trailing: _buildTrailing(request),
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
      '${'blood_types'.tr(context)}: ${request['bloodType'] ?? 'N/A'}', // Translated string
    );
  }

  Widget _buildTrailing(Map<String, dynamic> request) {
    return Text('${request['distance'] ?? '0'} km');
  }
}
