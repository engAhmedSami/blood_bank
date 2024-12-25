// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:blood_bank/core/utils/page_rout_builder.dart';
// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:blood_bank/feature/notification/notifications_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:blood_bank/core/utils/assets_images.dart';

// class HomeHeader extends StatelessWidget {
//   final String name;
//   final String? photoUrl;
//   final String userState;
//   final String bloodType;

//   const HomeHeader({
//     super.key,
//     required this.name,
//     this.photoUrl,
//     required this.userState,
//     required this.bloodType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 210,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: SvgPicture.asset(
//               Assets.imagesAppBar,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: 30,
//             left: 16,
//             child: CircleAvatar(
//               radius: 30,
//               backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
//                   ? NetworkImage(photoUrl!)
//                   : null,
//               backgroundColor: Colors.white,
//               child: photoUrl == null || photoUrl!.isEmpty
//                   ? const Icon(
//                       Icons.person,
//                       size: 30,
//                       color: Colors.grey,
//                     )
//                   : null,
//             ),
//           ),
//           Positioned(
//             top: 35,
//             left: 90,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${'hello'.tr(context)} $name!', // Localized hello message
//                   style: TextStyles.semiBold16.copyWith(color: Colors.white),
//                 ),
//                 Text(
//                   '${'user_state'.tr(context)}: $userState.', // Localized user state message
//                   style: TextStyles.regular13.copyWith(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 35,
//             right: 50,
//             child: IconButton(
//               icon: SvgPicture.asset(
//                 Assets.imagesChat,
//                 width: 24,
//                 height: 24,
//               ),
//               onPressed: () {},
//             ),
//           ),
//           Positioned(
//             top: 35,
//             right: 12,
//             child: IconButton(
//               icon: SvgPicture.asset(
//                 Assets.imagesNotfication,
//                 width: 24,
//                 height: 24,
//               ),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   buildPageRoute(
//                     const NotificationsPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/notification/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blood_bank/core/utils/assets_images.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final String userState;
  final String bloodType;

  const HomeHeader({
    super.key,
    required this.name,
    this.photoUrl,
    required this.userState,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من اللغة الحالية لتحديد الاتجاه
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final TextDirection textDirection =
        isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: SizedBox(
        height: 210,
        child: Stack(
          children: [
            // خلفية شريط العنوان
            Positioned.fill(
              child: SvgPicture.asset(
                Assets.imagesAppBar,
                fit: BoxFit.cover,
              ),
            ),
            // صورة المستخدم
            Positioned(
              top: 30,
              right: isArabic ? 16 : null,
              left: isArabic ? null : 16,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                    ? NetworkImage(photoUrl!)
                    : null,
                backgroundColor: Colors.white,
                child: photoUrl == null || photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            // تفاصيل المستخدم (الاسم وحالة المستخدم)
            Positioned(
              top: 35,
              right: isArabic ? 90 : null,
              left: isArabic ? null : 90,
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'hello'.tr(context)} $name!', // رسالة الترحيب
                    style: TextStyles.semiBold16.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${'user_state'.tr(context)}: $userState.', // حالة المستخدم
                    style: TextStyles.regular13.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            // أيقونة الدردشة
            Positioned(
              top: 35,
              left: isArabic ? 50 : null,
              right: isArabic ? null : 50,
              child: IconButton(
                icon: SvgPicture.asset(
                  Assets.imagesChat,
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
            ),
            // أيقونة الإشعارات
            Positioned(
              top: 35,
              left: isArabic ? 12 : null,
              right: isArabic ? null : 12,
              child: IconButton(
                icon: SvgPicture.asset(
                  Assets.imagesNotfication,
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    buildPageRoute(
                      const NotificationsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
