import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:intl/intl.dart';

class DonnerDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> donationData;

  const DonnerDetailsScreen({super.key, required this.donationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text('donation_details'.tr(context),
            style: TextStyle(
              color: Colors.white,
            )), // Localized title
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(context),
            const SizedBox(height: 20),
            // Details Section
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  // Build the header section
  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              donationData['name'] ??
                  'no_name'.tr(context), // Localized fallback
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              donationData['hospitalName'] ??
                  'no_hospital'.tr(context), // Localized fallback
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the details section
  Widget _buildDetailsSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(context, 'address', donationData['address']),
            _buildDetailItem(context, 'age', donationData['age'].toString()),
            _buildDetailItem(context, 'blood_type', donationData['bloodType']),
            _buildDetailItem(
                context, 'contact', donationData['contact'].toString()),
            _buildDetailItem(
                context, 'distance', donationData['distance'].toString()),
            _buildDetailItem(
                context, 'donation_type', donationData['donationType']),
            _buildDetailItem(context, 'gender', donationData['gender']),
            _buildDetailItem(
                context, 'id_card', donationData['idCard'].toString()),
            // _buildDetailItem(context, 'last_donation_date',
            //     donationData['lastRequestDate'].toString()),
            _buildDetailItem(
                context, 'last_donation_date', donationData['lastRequestDate']),

            _buildDetailItem(context, 'medical_conditions',
                donationData['medicalConditions']),
            _buildDetailItem(context, 'notes', donationData['notes']),
            _buildDetailItem(
                context, 'units', donationData['units'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String labelKey, dynamic value) {
    String formattedValue = _formatDate(value); // Format the value

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${labelKey.tr(context)}:', // Localized label
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formattedValue,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic value) {
    try {
      DateTime date;

      // Check if the value is a Timestamp
      if (value is Timestamp) {
        date = value.toDate();
      } else if (value is String) {
        date = DateTime.parse(value);
      } else {
        return value.toString(); // Fallback for unsupported types
      }

      // Format the date as "day - month - year"
      return DateFormat('dd - MM - yyyy').format(date);
    } catch (e) {
      // Return the raw value in case of an error
      return value.toString();
    }
  }
}
