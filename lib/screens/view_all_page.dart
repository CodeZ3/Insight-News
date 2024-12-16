import 'package:flutter/material.dart';
import '../model/article.dart';
import 'package:insight_today/widgets/news_card.dart';

class ViewAllPage extends StatelessWidget {
  final List<Article> articles;
  final String title;

  ViewAllPage({required this.articles, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: articles.isEmpty
          ? Center(child: Text("No articles available."))
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return NewsCard(article: articles[index]);
        },
      ),
    );
  }
}
