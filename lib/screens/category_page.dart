import 'package:flutter/material.dart';
import '../model/article.dart';
import 'package:insight_today/widgets/news_card.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final List<Article> articles;

  const CategoryPage({required this.title, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        centerTitle: true,
      ),
      body: articles.isEmpty
          ? const Center(child: Text("No articles available."))
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return NewsCard(article: articles[index]);
        },
      ),
    );
  }
}
