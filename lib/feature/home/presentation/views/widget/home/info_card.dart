import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? description;
  final String? url;

  const InfoCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.description,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   buildPageRoute(
        //     ArticleDetailsPage(
        //       title: title,
        //       description: description,
        //       imageUrl: imageUrl,
        //       url: url,
        //     ),
        //   ),
        // );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.4),
                  BlendMode.darken,
                ),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyles.bold16.copyWith(
                    color: AppColors.secondaryColor,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
