import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.subtitle,
    required this.image,
    required this.titel,
  });

  final String image;
  final String titel;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(image),
              ),
            ),
            const SizedBox(height: 18),
            Column(
              children: [
                Text(
                  titel,
                  style: TextStyles.bold23,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  subtitle,
                  style: TextStyles.regular17,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
