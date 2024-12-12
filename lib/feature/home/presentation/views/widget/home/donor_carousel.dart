import 'package:blood_bank/feature/home/presentation/views/widget/home/info_card.dart';
import 'package:flutter/material.dart';

class DonorCarousel extends StatelessWidget {
  const DonorCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125, // Set the height of the carousel
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 5, // Number of cards (can be updated based on API)
        itemBuilder: (context, index) {
          return Infocard(
            title: 'You can become a Blood Donor in',
            imageUrl:
                'https://lh3.googleusercontent.com/a/ACg8ocJrQqMm_FXSVxci5LR35YMRo--Wd3IZcvUkBzcTTBW0vSe7ZxKK=s96-c',
            onButtonTap: () {
              debugPrint('Tapped on card $index');
            },
          );
        },
      ),
    );
  }
}
