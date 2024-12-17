import 'source.dart';

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source'] != null ? Source.fromJson(json['source']) : Source.defaultSource(), // Handle null case
      author: json['author'] ?? 'Unknown Author',
      title: json['title'] ?? 'No Title', // Provide a default value
      description: json['description'] ?? '',
      url: json['url'] ?? '', // Provide a default value
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '', // Provide a default value
      content: json['content'] ?? '',
    );
  }

  // Convert Article to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      // Add other fields you want to save
    };
  }

}