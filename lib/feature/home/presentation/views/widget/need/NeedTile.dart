import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NeedTile extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic> data;

  const NeedTile({
    super.key,
    required this.requestId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final requestName = data['name'] ?? 'Unnamed Request';
    final requestDate = data['createdAt']?.toDate();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
          child: const Icon(
            Icons.bloodtype,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          requestName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: requestDate != null
            ? Text(
                "Created on: ${requestDate.toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editRequest(context, requestId, data);
            } else if (value == 'delete') {
              _deleteRequest(context, requestId);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text("edit".tr(context)), // Localized edit option
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text("delete".tr(context)), // Localized delete option
            ),
          ],
        ),
      ),
    );
  }

  // Edit Request
  void _editRequest(
      BuildContext context, String requestId, Map<String, dynamic> data) {
    // Implement edit functionality
    // For example, open a dialog or navigate to an edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("edit_request".tr(context)),
        content: Text("Edit functionality not implemented yet."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("close".tr(context)),
          ),
        ],
      ),
    );
  }

  // Delete Request
  void _deleteRequest(BuildContext context, String requestId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete_request".tr(context)),
        content: Text("confirm_delete_request".tr(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel deletion
            },
            child: Text("cancel".tr(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirm deletion
            },
            child: Text("delete".tr(context)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Delete the request from Firestore
      await FirebaseFirestore.instance
          .collection('neederRequest')
          .doc(requestId)
          .delete();
    }
  }
}
