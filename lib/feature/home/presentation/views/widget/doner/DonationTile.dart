import 'package:blood_bank/feature/home/presentation/views/widget/doner/DonnerDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationTile extends StatelessWidget {
  final String donationId;
  final Map<String, dynamic> data;

  const DonationTile({
    super.key,
    required this.donationId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data['name'] ?? 'No Name'),
      subtitle: Text('Hospital: ${data['hospitalName'] ?? 'No Hospital'}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _editDonation(context, donationId, data),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteDonation(context, donationId),
          ),
        ],
      ),
      onTap: () {
        _handleDonationTap(
            context, donationId, data); // Pass data to handle tap
      },
    );
  }

  // Handle donation tap
  void _handleDonationTap(
      BuildContext context, String donationId, Map<String, dynamic> data) {
    // Navigate to the DonationDetailsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonnerDetailsScreen(donationData: data),
      ),
    );
  }

  // Edit donation
  void _editDonation(
      BuildContext context, String donationId, Map<String, dynamic> data) {
    // Open a dialog or navigate to an edit screen
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: data['name']);
        final hospitalController =
            TextEditingController(text: data['hospitalName']);

        return AlertDialog(
          title: const Text('Edit Donation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: 'Hospital'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the donation in Firestore
                await FirebaseFirestore.instance
                    .collection('donerRequest')
                    .doc(donationId)
                    .update({
                  'name': nameController.text,
                  'hospitalName': hospitalController.text,
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete donation
  void _deleteDonation(BuildContext context, String donationId) async {
    // Show a confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Donation'),
          content: const Text('Are you sure you want to delete this donation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Delete the donation from Firestore
      await FirebaseFirestore.instance
          .collection('donerRequest')
          .doc(donationId)
          .delete();
    }
  }
}
