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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(
              // استخدم withValues بدلاً من withOpacity

              alpha: 0.2,
            ),
            blurRadius: 8,
            spreadRadius: 5,
            offset: const Offset(0, 4), // الشادو للأسفل
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
          Align(
            alignment: Alignment.bottomRight,
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
