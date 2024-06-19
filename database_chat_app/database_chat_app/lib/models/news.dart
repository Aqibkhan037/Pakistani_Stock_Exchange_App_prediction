class NewsArticle {
  final String title;
  final String description;
  final String? imageUrl;
  final String url;
  final String content;

  NewsArticle({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.url,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['urlToImage'] as String?,
      url: json['url'] as String,
      content: json['content'] as String,
    );
  }
}
