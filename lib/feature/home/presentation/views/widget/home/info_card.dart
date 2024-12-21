import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/health_article_details.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String image;
  final String? description;
  final String? content;
  final String? url;
  final String? publishedAt;
  final String? sourceName;
  final String? sourceUrl;

  const InfoCard({
    super.key,
    required this.title,
    required this.image,
    this.description,
    this.content,
    this.url,
    this.publishedAt,
    this.sourceName,
    this.sourceUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          buildPageRoute(
            ArticleDetailsPage(
              title: title,
              description: description,
              content: content,
              url: url,
              imageUrl: image,
              publishedAt: publishedAt,
              sourceName: sourceName,
              sourceUrl: sourceUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.4),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(22),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade500,
          //     blurRadius: 5,
          //     spreadRadius: 0.5,
          //     offset: const Offset(0, 5),
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
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
