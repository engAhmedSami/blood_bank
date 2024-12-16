import 'dart:developer';
import 'package:blood_bank/feature/home/manager/models/health_model.dart';
import 'package:dio/dio.dart';

class HealthRequest {
  final Dio dio;
  final String apiKey = 'fc9acce33fa2408697231299f6a574b2';

  HealthRequest(
    this.dio,
  );

  Future<List<HealthModel>> news({required String category}) async {
    try {
      final String url =
          'https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=$apiKey';

      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        List<dynamic> articles = jsonData['articles'];

        List<HealthModel> dataList =
            articles.map((article) => HealthModel.fromJson(article)).toList();

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
