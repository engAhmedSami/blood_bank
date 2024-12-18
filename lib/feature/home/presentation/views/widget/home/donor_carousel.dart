import 'package:blood_bank/core/services/health_request.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/health_cubit/health_cubit.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/health_cubit/health_state.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DonorCarousel extends StatelessWidget {
  const DonorCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HealthCubit(HealthRequest(Dio()))..fetchHealthNews(),
      child: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          if (state is HealthLoading) {
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Skeletonizer(
                    child: Container(
                      width: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is HealthSuccess) {
            final articles = state.articles;
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return InfoCard(
                    content: article.content,
                    url: article.url,
                    description: article.description,
                    title: article.title,
                    image: article.image ??
                        'https://fallback-image.com/default.jpg',
                    publishedAt: article.publishedAt,
                    sourceName: article.sourceName,
                    sourceUrl: article.sourceUrl,
                  );
                },
              ),
            );
          } else if (state is HealthError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
