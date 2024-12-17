import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/under_line.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  final String title;
  final String? description;
  final String? content;
  final String? url;
  final String? imageUrl;
  final String? publishedAt;
  final String? sourceName;
  final String? sourceUrl;

  const ArticleDetailsPage({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.sourceName,
    this.sourceUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 300,
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
              child: Column(children: [
                Text(
                  title,
                  style: TextStyles.semiBold19
                      .copyWith(color: AppColors.primaryColor),
                ),
                const SizedBox(height: 12),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyles.regular16.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 12),
                if (content != null)
                  Text(
                    content!,
                    style: TextStyles.semiBold16,
                  ),
                const SizedBox(height: 20),
                if (publishedAt != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Published: $publishedAt",
                        style:
                            TextStyles.regular16.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                if (sourceName != null)
                  Row(
                    children: [
                      const Icon(Icons.source, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Source: $sourceName",
                          style:
                              TextStyles.regular16.copyWith(color: Colors.grey),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (sourceUrl != null)
                        TextButton(
                          onPressed: () {
                            if (Uri.tryParse(sourceUrl!) != null) {
                              launchUrl(Uri.parse(sourceUrl!));
                            }
                          },
                          child: UnderLine(
                            child: Text(
                              "Visit Source",
                              style: TextStyles.semiBold13
                                  .copyWith(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 12),
                if (url != null)
                  CustomButton(
                    onPressed: () => launchUrl(Uri.parse(url!)),
                    text: "Read Full Article",
                  ),
              ]),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Article Details",
        style: TextStyles.semiBold24.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF800000),
    );
  }
}
