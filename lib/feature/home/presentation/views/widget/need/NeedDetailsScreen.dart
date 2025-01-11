import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class NeedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> needData;

  const NeedDetailsScreen({super.key, required this.needData});

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
            )),
        title: Text(
          'need_details'.tr(context),
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

  Widget _buildHeaderSection(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      color: AppColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            Row(
              spacing: 10,
              children: [
                Text(
                  'patientName'.tr(context), // Localized label
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  needData['patientName'] ??
                      'no_name'.tr(context), // Localized fallback
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Hospital Name
            Row(
              children: [
                Text(
                  'hospital_name'.tr(context), // Localized label
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  needData['hospitalName'] ??
                      'no_hospital'.tr(context), // Localized fallback
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Build the details section
  Widget _buildDetailsSection(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(context, 'patientName', needData['patientName']),
            _buildDetailItem(context, 'address', needData['address']),
            _buildDetailItem(context, 'age', needData['age'].toString()),
            _buildDetailItem(context, 'blood_type', needData['bloodType']),
            _buildDetailItem(
                context, 'contact', needData['contact'].toString()),
            _buildDetailItem(
              context,
              'dateTime',
              Validators.formatDate(
                  needData['dateTime']), // Use Validators.formatDate
            ),
            _buildDetailItem(
                context, 'donation_type', needData['donationType']),
            _buildDetailItem(context, 'gender', needData['gender']),
            _buildDetailItem(context, 'id_card', needData['idCard'].toString()),
            _buildDetailItem(
                context, 'medical_conditions', needData['medicalConditions']),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
