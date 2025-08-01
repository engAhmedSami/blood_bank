import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({
    super.key,
    required this.requests,
    required this.snapshot,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          useSafeArea: true,
          enableDrag: true,
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            // تأكد من توفير هيكل تخطيط مناسب
            return SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.8, // قيود واضحة للطول
              child: _buildContent(context),
            );
          },
        );
      },
      child: Text(
        'see_all'.tr(context),
        style: TextStyles.semiBold14.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CoustomCircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: CustomDialog(
          title: 'error_occurred'.tr(context),
          content: 'error_occurred: ${snapshot.error}'.tr(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index].data();
        return ListTile(
          leading: _buildUserAvatar(context, request['uId']),
          title: Text(request['name'] ?? 'No Name'),
          subtitle: _buildSubtitle(request, context),
          trailing: _buildTrailing(request, context),
        );
      },
    );
  }

  Widget _buildUserAvatar(BuildContext context, String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: CoustomCircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Icon(Icons.error, color: Colors.white),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final photoUrl = userData['photoUrl'];

        return CircleAvatar(
          radius: 25,
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : null,
          backgroundColor: Colors.grey,
          child: photoUrl == null || photoUrl.isEmpty
              ? Icon(Icons.person, color: Colors.white)
              : null,
        );
      },
    );
  }

  Widget _buildSubtitle(Map<String, dynamic> request, BuildContext context) {
    return Text(
      '${'blood_types'.tr(context)}: ${request['bloodType'].toString().tr(context)}',
    );
  }

  Widget _buildTrailing(Map<String, dynamic> request, BuildContext context) {
    return Text('${request['distance'] ?? '0'} ${'km'.tr(context)}');
  }
}
