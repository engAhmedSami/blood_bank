class HealthModel {
  final String? image;
  final String title;
  final String? description;
  final String? url;

  HealthModel(
      {required this.image,
      required this.title,
      required this.description,
      required this.url});
  factory HealthModel.fromJson(json) {
    return HealthModel(
      image: json['image'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
