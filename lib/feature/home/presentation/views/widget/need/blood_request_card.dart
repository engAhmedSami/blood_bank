// import 'package:blood_bank/core/utils/app_colors.dart';
// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:blood_bank/core/utils/assets_images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';

// class BloodRequestCard extends StatelessWidget {
//   final Map<String, dynamic> request;
//   final VoidCallback onAccept;
//   final VoidCallback onDecline;

//   const BloodRequestCard({
//     super.key,
//     required this.request,
//     required this.onAccept,
//     required this.onDecline,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.4),
//               blurRadius: 6,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       Assets.imagesCircle,
//                       width: 45,
//                     ),
//                     SvgPicture.asset(
//                       Assets.imagesNblood,
//                       width: 28,
//                     ),
//                     Text(request['bloodType'] ?? 'N/A',
//                         style: TextStyles.semiBold14.copyWith(
//                           color: Colors.white,
//                         )),
//                   ],
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Emergency ${request['bloodType']} Blood Needed',
//                         style: TextStyles.bold16
//                             .copyWith(color: AppColors.primaryColor),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             Assets.imagesHospital,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             request['hospitalName'] ?? 'Unknown Hospital',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           SvgPicture.asset(
//                             Assets.imagesOcloc,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             DateFormat('dd MMM yyyy')
//                                 .format(request['dateTime'].toDate()),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 55,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           side: const BorderSide(
//                             color: AppColors.primaryColor,
//                           ),
//                         ),
//                         backgroundColor: AppColors.primaryColor,
//                       ),
//                       onPressed: onAccept,
//                       child: Text(
//                         'Accept',
//                         style:
//                             TextStyles.semiBold16.copyWith(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: SizedBox(
//                     height: 55,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           side: const BorderSide(
//                             color: AppColors.primaryColor,
//                           ),
//                         ),
//                         backgroundColor: Colors.white,
//                       ),
//                       onPressed: onDecline,
//                       child: Text(
//                         'Decline',
//                         style:
//                             TextStyles.semiBold16.copyWith(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class BloodRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BloodRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

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
              color: Colors.black.withValues(alpha: .1),
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
                      request['bloodType'] ?? 'n_a'.tr(context),
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
                        'Emergency ${request['bloodType']} Blood Needed',
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
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: onAccept,
                      child: Text(
                        'accept'.tr(context),
                        style:
                            TextStyles.semiBold16.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: onDecline,
                      child: Text(
                        'decline'.tr(context),
                        style:
                            TextStyles.semiBold16.copyWith(color: Colors.black),
                      ),
                    ),
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
