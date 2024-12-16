import 'package:get/get.dart';
import '../model/article.dart';
import '../service/api_service.dart';

class ArticleController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Article> _articles = <Article>[].obs;
  final RxList<Article> _trendingArticles = <Article>[].obs;
  final RxBool _isLoading = false.obs;

  List<Article> get articles => _articles;
  List<Article> get trendingArticles => _trendingArticles;
  bool get isLoading => _isLoading.value;

  //fetching articles
  Future<void> fetchArticles(String category) async {
    _isLoading.value = true;
    _articles.clear();

    try {
      _articles.value = await _apiService.fetchArticles(category);
    } catch (error) {
      print('Error fetching $category articles: $error');
      _articles.clear();
    }

    _isLoading.value = false;
  }

  //fetching trending articles
  Future<void> fetchTrendingArticles() async {
    _isLoading.value = true;
    _trendingArticles.clear();

    try {
      _trendingArticles.value = await _apiService.fetchTrendingArticles();
    } catch (error) {
      print('Error fetching trending articles: $error');
      _trendingArticles.clear();
    }

    _isLoading.value = false;
  }
}