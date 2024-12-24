import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/SeeAll.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RequestsForDonation extends StatelessWidget {
  const RequestsForDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('donerRequest').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CoustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error}'));
        }

        final requests = snapshot.data?.docs ?? [];

        final reversedRequests = requests.reversed.toList();

        if (reversedRequests.isEmpty) {
          return Center(
              child: Text('no_donation_requests_available'.tr(context)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'donation_requests'.tr(context),
                    style: TextStyles.semiBold16,
                  ),
                  SeeAll(requests: reversedRequests),
                ],
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount:
                    reversedRequests.length >= 4 ? 4 : reversedRequests.length,
                itemBuilder: (context, index) {
                  final request = reversedRequests[index].data();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 5,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            request['photoUrl'] ??
                                'https://i.stack.imgur.com/l60Hf.png',
                          ),
                        ),
                        title: Text(
                          request['name'] ?? 'no_name'.tr(context),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            Text(
                              request['hospitalName'] ??
                                  'unknown_hospital'.tr(context),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.imagesBlooddrop,
                                      height: 35,
                                    ),
                                    Text(
                                      '${request['bloodType'] ?? 'N/A'}',
                                      style: TextStyles.semiBold11.copyWith(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff598158),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    '${request['distance'] ?? '0'} km',
                                    style: TextStyles.semiBold12
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
