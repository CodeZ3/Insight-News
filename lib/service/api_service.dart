import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/article.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  final String apiKey = '2191b9c0ed8e439da22ca07e3b8f03d3';
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchArticles(String category) async {
    final url = Uri.parse(
        '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok' && jsonData.containsKey('articles')) {
          final List<dynamic> articlesData = jsonData['articles'];

          return articlesData
              .where((article) =>
          article['urlToImage'] != null &&
              article['description'] != null)
              .map((data) => Article.fromJson(data))
              .toList();
        } else {
          print('No articles found or invalid response');
          return [];
        }
      } else {
        print('Failed to load articles. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  Future<List<Article>> fetchTrendingArticles() async {
    final url = Uri.parse(
        '$baseUrl/top-headlines?sources=bbc-news&apiKey=$apiKey');
    return await _fetchArticlesFromUrl(url);
  }

  Future<List<Article>> fetchNews({required String query, String? from, String? sortBy}) async {
    final url = Uri.parse(
        '$baseUrl/everything?q=$query${from != null ? '&from=$from' : ''}${sortBy != null ? '&sortBy=$sortBy' : ''}&apiKey=$apiKey');
    return await _fetchArticlesFromUrl(url);
  }

  Future<List<Article>> _fetchArticlesFromUrl(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok' && jsonData.containsKey('articles')) {
          final List<dynamic> articlesData = jsonData['articles'];

          return articlesData
              .where((element) => element["urlToImage"] != null && element["description"] != null)
              .map((data) => Article.fromJson(data))
              .toList();
        } else {
          print('No articles found or invalid response format.');
          return [];
        }
      } else {
        print('Failed to fetch articles. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch articles');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }
}