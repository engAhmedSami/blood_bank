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

  // Convert JSON to HealthModel instance
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

  // Convert HealthModel instance to Map (for saving into a database)
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'url': url,
      'content': content,
      'publishedAt': publishedAt,
      'sourceName': sourceName,
      'sourceUrl': sourceUrl,
    };
  }

  // Convert Map to HealthModel instance
  factory HealthModel.fromMap(Map<String, dynamic> map) {
    return HealthModel(
      image: map['image'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      content: map['content'],
      publishedAt: map['publishedAt'],
      sourceName: map['sourceName'],
      sourceUrl: map['sourceUrl'],
    );
  }
}
