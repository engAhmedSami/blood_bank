class HealthModel {
  final String? urlToImage;
  final String title;
  final String? description;
  final String? url;

  HealthModel(
      {required this.urlToImage,
      required this.title,
      required this.description,
      required this.url});
  factory HealthModel.fromJson(json) {
    return HealthModel(
      urlToImage: json['urlToImage'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
