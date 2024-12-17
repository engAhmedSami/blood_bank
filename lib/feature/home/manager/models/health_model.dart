class HealthModel {
  final String? image;
  final String title;
  final String? description;
  final String? url;
  final String? content;
  final String? publishedAt;
  final String? sourceName;
  final String? sourceUrl;

  HealthModel({
    required this.image,
    required this.title,
    required this.description,
    required this.url,
    required this.content,
    required this.publishedAt,
    required this.sourceName,
    required this.sourceUrl,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) {
    return HealthModel(
      image: json['image'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      content: json['content'],
      publishedAt: json['publishedAt'],
      sourceName: json['source']?['name'],
      sourceUrl: json['source']?['url'],
    );
  }
}
