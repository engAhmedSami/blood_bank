import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';

class DonnerDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> donationData;

  const DonnerDetailsScreen({super.key, required this.donationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'donation_details'.tr(context),
          style: TextStyle(
            color: Colors.white,
          ),
        ), // Localized title
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
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
      color: AppColors.secondaryColor,
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
                color: AppColors.primaryColorB,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              donationData['hospitalName'] ??
                  'no_hospital'.tr(context), // Localized fallback
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryColorB.withOpacity(0.7),
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
      color: AppColors.secondaryColor,
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
            _buildDetailItem(
              context,
              'last_donation_date',
              donationData['lastDonationDate']?.toString() ??
                  'not_available'.tr(context), // Localized fallback
            ),
            _buildDetailItem(
              context,
              'last_request_date',
              donationData['lastRequestDate']?.toString() ??
                  'not_available'.tr(context), // Localized fallback
            ),
            _buildDetailItem(context, 'medical_conditions',
                donationData['medicalConditions']),
            _buildDetailItem(
              context,
              'next_donation_date',
              donationData['nextDonationDate']?.toString() ??
                  'not_available'.tr(context), // Localized fallback
            ),
            _buildDetailItem(context, 'notes', donationData['notes']),
            _buildDetailItem(
                context, 'units', donationData['units'].toString()),
          ],
        ),
      ),
    );
  }

  // Build a single detail item
  Widget _buildDetailItem(BuildContext context, String labelKey, String value) {
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
                color: AppColors.primaryColorB,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColorB.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
