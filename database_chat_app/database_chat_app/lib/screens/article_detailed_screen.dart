import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' show parse;
import 'package:database_chat_app/models/news.dart'; // Import the file where NewsArticle is defined

class ArticleDetailScreen extends StatefulWidget {
  final NewsArticle article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  String fullContent = '';

  @override
  void initState() {
    super.initState();
    fetchArticleContent();
  }

  void fetchArticleContent() async {
    try {
      final response = await http.get(Uri.parse(widget.article.url));
      if (response.statusCode == 200) {
        setState(() {
          fullContent = response.body;
        });
      }
    } catch (e) {
      // Handle error fetching article content
      print('Error fetching article content: $e');
    }
  }

  String removeHtmlTags(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Customize app bar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.article.imageUrl != null)
                Image.network(
                  widget.article.imageUrl!,
                  height: 200, // Adjust image height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              Text(
                widget.article.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.article.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                removeHtmlTags(fullContent),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
