import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/article.dart';

class BookmarkController extends GetxController {
  final _storage = GetStorage();
  RxList<Article> bookmarkedArticles = <Article>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void addBookmark(Article article) {
    if (!isBookmarked(article)) {
      bookmarkedArticles.add(article);
      saveBookmarks();
    }
  }

  void removeBookmark(Article article) {
    bookmarkedArticles.removeWhere((a) => a.title == article.title);
    saveBookmarks();
  }

  bool isBookmarked(Article article) {
    return bookmarkedArticles.any((a) => a.title == article.title);
  }

  void saveBookmarks() {
    final bookmarkList = bookmarkedArticles.map((article) => article.toJson()).toList();
    _storage.write('bookmarks', bookmarkList);
  }

  void loadBookmarks() {
    final savedBookmarks = _storage.read('bookmarks') ?? [];
    bookmarkedArticles.value = savedBookmarks
        .map<Article>((json) => Article.fromJson(json))
        .toList();
  }

  void clearBookmarks() {
    bookmarkedArticles.clear();
    _storage.remove('bookmarks');
  }
}