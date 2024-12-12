import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Infocard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onButtonTap;

  const Infocard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // عرض البطاقة
      margin: const EdgeInsets.only(right: 20), // مسافة بين البطاقات
      padding: const EdgeInsets.all(16), // مسافة داخلية متماثلة
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(22), // الحواف دائرية
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Spacer(), // إضافة مسافة مرنة بين النص والصورة
          Align(
            alignment: Alignment.centerRight,
            child: Image.network(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
