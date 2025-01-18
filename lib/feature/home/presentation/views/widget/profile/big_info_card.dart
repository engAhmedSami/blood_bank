// import 'package:blood_bank/core/utils/assets_images.dart';
// import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
// import 'package:blood_bank/core/widget/coustom_dialog.dart';
// import 'package:blood_bank/feature/home/presentation/views/widget/profile/info_column.dart';
// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BigInfoCard extends StatelessWidget {
//   final String savedLives;
//   final String bloodGroup;
//   final String nextDonationDate;

//   const BigInfoCard({
//     super.key,
//     required this.savedLives,
//     required this.bloodGroup,
//     required this.nextDonationDate,
//   });

//   void _handleNextDonationDate(BuildContext context, DocumentSnapshot request) {
//     final data = request.data() as Map<String, dynamic>?; // Explicit cast
//     if (data != null && data.containsKey('lastRequestDate')) {
//       final nextDonationTimestamp = data['lastRequestDate'];
//       if (nextDonationTimestamp != null && nextDonationTimestamp is Timestamp) {
//         DateTime nextDonationDateTime = nextDonationTimestamp.toDate();
//         // Check if the next donation date has passed by at least one day
//         if (nextDonationDateTime
//             .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _promptUserToSetNewDate(context, request);
//           });
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // double width = MediaQuery.of(context).size.width;
//     final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserUid == null) {
//       return const Center(child: Text('No user is logged in'));
//     }
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('donerRequest')
//           .where('uId', isEqualTo: currentUserUid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CoustomCircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return CustomDialog(
//             title: 'error_occurred'.tr(context),
//             content: 'error_occurred: ${snapshot.error}'.tr(context),
//           );
//         }

//         final requests = snapshot.data?.docs ?? [];
//         debugPrint('Number of requests: ${requests.length}');

//         String formattedNextDonationDate = 'next_donation_date'.tr(context);
//         bool isTodayDonationDay = false;

//         if (requests.isNotEmpty) {
//           final request = requests[0];
//           debugPrint('Request data: ${request.data()}');
//           _handleNextDonationDate(context, request);

//           final data = request.data() as Map<String, dynamic>?; // Explicit cast
//           if (data != null && data.containsKey('lastRequestDate')) {
//             final nextDonationTimestamp = data['lastRequestDate'];
//             if (nextDonationTimestamp != null &&
//                 nextDonationTimestamp is Timestamp) {
//               DateTime nextDonationDateTime = nextDonationTimestamp.toDate();
//               formattedNextDonationDate =
//                   DateFormat('yyyy-MM-dd').format(nextDonationDateTime);

//               // Check if today is the donation day
//               if (nextDonationDateTime.year == DateTime.now().year &&
//                   nextDonationDateTime.month == DateTime.now().month &&
//                   nextDonationDateTime.day == DateTime.now().day) {
//                 isTodayDonationDay = true;
//               }
//             }
//           } else {
//             formattedNextDonationDate =
//                 'no_next_donation_scheduled'.tr(context);
//           }
//         }

//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade400,
//                 blurRadius: 5,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InfoColumn(title: savedLives, image: Assets.imagesLifesaved),
//               // SizedBox(width: width * 0.1),
//               InfoColumn(title: bloodGroup, image: Assets.imagesBlood),
//               // SizedBox(width: width * 0.15),
//               InfoColumn(
//                 title: isTodayDonationDay
//                     ? 'Today is your donation day'.tr(context)
//                     : formattedNextDonationDate,
//                 image: Assets.imagesNextdonation,
//                 isTodayDonationDay: isTodayDonationDay,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _promptUserToSetNewDate(BuildContext context, DocumentSnapshot request) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Donation Day Passed'),
//         content: const Text(
//             'Your donation day has passed. Would you like to set a new donation date?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               FirebaseFirestore.instance
//                   .collection('donerRequest')
//                   .doc(request.id)
//                   .delete()
//                   .then((_) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content: Text('Request deleted successfully.')),
//                 );
//                 Navigator.pop(context); // Close the dialog
//               }).catchError((error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error: $error')),
//                 );
//               });
//             },
//             child: const Text('Skip'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Add your navigation logic here
//               Navigator.pop(context); // Close the dialog
//             },
//             child: const Text('Set New Date'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/info_column.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BigInfoCard extends StatelessWidget {
  final String savedLives;
  final String bloodGroup;
  final String nextDonationDate;

  const BigInfoCard({
    super.key,
    required this.savedLives,
    required this.bloodGroup,
    required this.nextDonationDate,
  });

  void _handleNextDonationDate(BuildContext context, DocumentSnapshot request) {
    final data = request.data() as Map<String, dynamic>?; // Explicit cast
    if (data != null && data.containsKey('nextDonationDate')) {
      final nextDonationTimestamp = data['nextDonationDate'];
      if (nextDonationTimestamp != null && nextDonationTimestamp is Timestamp) {
        DateTime nextDonationDateTime = nextDonationTimestamp.toDate();
        // Check if the next donation date has passed by at least one day
        if (nextDonationDateTime
            .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _promptUserToSetNewDate(context, request);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) {
      return const Center(child: Text('No user is logged in'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('donerRequest')
          .where('uId', isEqualTo: currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CoustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return CustomDialog(
            title: 'error_occurred'.tr(context),
            content: 'error_occurred: ${snapshot.error}'.tr(context),
          );
        }

        final requests = snapshot.data?.docs ?? [];
        debugPrint('Number of requests: ${requests.length}');

        String formattedNextDonationDate = 'next_donation_date'.tr(context);
        bool isTodayDonationDay = false;

        if (requests.isNotEmpty) {
          final request = requests[0];
          debugPrint('Request data: ${request.data()}');
          _handleNextDonationDate(context, request);

          final data = request.data() as Map<String, dynamic>?; // Explicit cast
          if (data != null && data.containsKey('nextDonationDate')) {
            final nextDonationTimestamp = data['nextDonationDate'];
            if (nextDonationTimestamp != null &&
                nextDonationTimestamp is Timestamp) {
              DateTime nextDonationDateTime = nextDonationTimestamp.toDate();
              formattedNextDonationDate =
                  DateFormat('yyyy-MM-dd').format(nextDonationDateTime);

              // Check if today is the donation day
              if (nextDonationDateTime.year == DateTime.now().year &&
                  nextDonationDateTime.month == DateTime.now().month &&
                  nextDonationDateTime.day == DateTime.now().day) {
                isTodayDonationDay = true;
              }
            }
          } else {
            formattedNextDonationDate =
                'no_next_donation_scheduled'.tr(context);
          }
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(title: savedLives, image: Assets.imagesLifesaved),
              // SizedBox(width: width * 0.1),
              InfoColumn(title: bloodGroup, image: Assets.imagesBlood),
              // SizedBox(width: width * 0.15),
              InfoColumn(
                title: isTodayDonationDay
                    ? 'Today is your donation day'.tr(context)
                    : formattedNextDonationDate,
                image: Assets.imagesNextdonation,
                isTodayDonationDay: isTodayDonationDay,
              ),
            ],
          ),
        );
      },
    );
  }

  void _promptUserToSetNewDate(BuildContext context, DocumentSnapshot request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Donation Day Passed'),
        content: const Text(
            'Your donation day has passed. Would you like to set a new donation date?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog without deleting the request
              Navigator.pop(context);
            },
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: () {
              // Add your navigation logic here
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Set New Date'),
          ),
        ],
      ),
    );
  }
}
