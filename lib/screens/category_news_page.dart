import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';
import '../widgets/news_card.dart';

class CategoryNewsPage extends StatefulWidget {
  final String category;

  const CategoryNewsPage({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryNewsPageState createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  final ArticleController articleController = Get.find();

  @override
  void initState() {
    super.initState();
    // Fetch articles for the specific category when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      articleController.fetchArticles(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.toUpperCase()} News'),
        centerTitle: true,
      ),
      body: Obx(() =>
      articleController.isLoading
          ? Center(child: CircularProgressIndicator())
          : articleController.articles.isEmpty
          ? Center(child: Text('No articles available for ${widget.category} category.'))
          : ListView.builder(
        itemCount: articleController.articles.length,
        itemBuilder: (context, index) {
          return NewsCard(article: articleController.articles[index]);
        },
      )
      ),
    );
  }
}