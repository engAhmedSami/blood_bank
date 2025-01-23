import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class BloodRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;

  const BloodRequestCard({
    super.key,
    required this.request,
  });

  String getStatusMessage(BuildContext context) {
    switch (request['status']) {
      case 'accepted':
        return 'request_accepted'.tr(context);
      case 'rejected':
        return 'request_rejected'.tr(context);
      case 'pending':
      default:
        return 'request_pending'.tr(context);
    }
  }

  Color getStatusColor() {
    switch (request['status']) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return AppColors.backgroundColor.withValues(alpha: 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.imagesCircle,
                      width: 45,
                    ),
                    SvgPicture.asset(
                      Assets.imagesNblood,
                      width: 28,
                    ),
                    Text(
                      request['bloodType'].toString().tr(context),
                      style: TextStyles.semiBold14.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'emergency'.tr(context)} ${request['bloodType'].toString().tr(context)} ${'blood_needed'.tr(context)}',
                        style: TextStyles.bold16
                            .copyWith(color: AppColors.primaryColor),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.imagesHospital,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            request['hospitalName'] ??
                                'unknown_hospital'.tr(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            Assets.imagesOcloc,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request['dateTime'] != null
                                ? DateFormat('dd MMM yyyy')
                                    .format(request['dateTime'].toDate())
                                : 'unknown_date'.tr(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: getStatusColor(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    getStatusMessage(context),
                    style: TextStyles.semiBold16.copyWith(
                      color: getStatusColor(),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
