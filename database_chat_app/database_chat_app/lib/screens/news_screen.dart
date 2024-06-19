import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:database_chat_app/models/news.dart';
import 'package:database_chat_app/screens/article_detailed_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsArticle> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNewsArticles();
  }

  Future<void> fetchNewsArticles() async {
    // Replace 'YOUR_API_KEY_HERE' with your actual news API key
    String apiKey = 'd9b1d0adf5254bc2b6084197940d9be5';
    String query =
        'stock market OR Karachi Stock Exchange OR PSX OR stock trading';

    String apiUrl = 'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articlesData = data['articles'] as List;

        setState(() {
          articles = articlesData
              .map((article) => NewsArticle.fromJson(article))
              .toList();
        });
      } else {
        // Handle any error or non-200 status codes here
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any network or other exceptions here
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pakistani Stock Market News',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff368983),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailScreen(article: articles[index]),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (articles[index].imageUrl != null)
                    Image.network(
                      articles[index].imageUrl!,
                      height: 200, // Adjust image height as needed
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          articles[index].title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          articles[index].description,
                          maxLines: 2, // Limit description to 2 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
