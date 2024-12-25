import 'dart:developer';

import 'package:blood_bank/core/services/sql_helper_health_request.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/manager/models/health_model.dart';
import 'package:dio/dio.dart';

class HealthRequest {
  final Dio dio;
  final SQlHelperHealthRequest dbHelper = SQlHelperHealthRequest();
  // final String apiKey = '0458895a45f8c3f3c2cac14bad712856';
  final String apiKey = '63e3e22cd4f0d7cbff1d45bc3f908704';

  HealthRequest(this.dio);

  Future<List<HealthModel>> news({required String category}) async {
    try {
      final String url =
          'https://gnews.io/api/v4/top-headlines?country=us&category=health&apikey=$apiKey';

      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        log('Response Data: ${response.data}');

        Map<String, dynamic> jsonData = response.data;
        List<dynamic> articles = jsonData['articles'];

        final List<HealthModel> dataList =
            articles.map((article) => HealthModel.fromJson(article)).toList();

        // Cache the fetched data into the database
        for (var article in dataList) {
          await dbHelper.insertArticle(article);
        }

        return dataList;
      } else {
        log('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }
}
