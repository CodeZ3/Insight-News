import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/article.dart';
import '../controllers/article_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/bookmark_controller.dart';
import '../widgets/category_buttons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:insight_today/screens/category_news_page.dart';
import '../widgets/news_card.dart';
import 'article_details.dart';
import 'view_all_page.dart';
import 'bookmarks_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ArticleController articleController = Get.find();
  final ThemeController themeController = Get.find();
  final BookmarkController bookmarkController = Get.find(); // Add this line

  int _currentPage = 0; // For bottom navigation

  final List<Map<String, String>> categories = [
    {'name': 'Business', 'image': 'assets/business.png'},
    {'name': 'Entertainment', 'image': 'assets/entertainment.png'},
    {'name': 'Sports', 'image': 'assets/sports.png'},
    {'name': 'Health', 'image': 'assets/health.png'},
    {'name': 'Science', 'image': 'assets/science.png'},
    {'name': 'Technology', 'image': 'assets/technology.png'},
  ];

  int _currentIndex = 0;

  // List of pages for bottom navigation
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      articleController.fetchTrendingArticles();
      articleController.fetchArticles("general");
    });

    // Initialize pages for bottom navigation
    _pages = [
      _buildHomeContent(), // Home page content
      BookmarksScreen(), // Bookmarks screen
    ];
  }

  // Method to build home content
  Widget _buildHomeContent() {
    return Column(
      children: [
        SizedBox(height: 16),

        // Category Buttons
        CategoryButtons(
          categories: categories,
          onCategorySelected: (categoryName) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryNewsPage(category: categoryName),
              ),
            );
          },
        ),
        SizedBox(height: 10),

        // Trending News Section
        sectionHeader(
          title: 'Trending News',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewAllPage(
                  title: 'Trending News',
                  articles: articleController.trendingArticles,
                ),
              ),
            );
          },
        ),

        // Trending News Carousel
        Obx(() {
          final trendingArticles = articleController.trendingArticles;
          return trendingNewsCarousel(trendingArticles);
        }),

        // General News Section
        sectionHeader(
          title: 'General News',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewAllPage(
                  title: 'General News',
                  articles: articleController.articles,
                ),
              ),
            );
          },
        ),

        // general news list
        Obx(() {
          final articles = articleController.articles;
          return Expanded(child: normalNewsList(articles));
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Insight',
                style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              TextSpan(
                text: 'News',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(articleController.articles),
              );
            },
          ),
          Obx(() => IconButton(
            icon: Icon(themeController.isDarkMode.value
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeController.toggleTheme();
            },
          )),
        ],
      ),
      body: _pages[_currentPage], // Use current page from bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Obx(() => Badge(
              label: Text('${bookmarkController.bookmarkedArticles.length}'),
              child: Icon(Icons.bookmark),
            )),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  Widget sectionHeader({required String title, required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget trendingNewsCarousel(List trendingArticles) {
    if (trendingArticles.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final displayedArticles = trendingArticles.take(6).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: CarouselSlider.builder(
            itemCount: displayedArticles.length,
            itemBuilder: (context, index, realIndex) {
              final article = displayedArticles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetails(article: article),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Stack(
                    children: [
                      if (article.urlToImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            article.urlToImage,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            article.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: displayedArticles.length > 6 ? 6 : displayedArticles.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.red,
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
              expansionFactor: 4,
              spacing: 7,
            ),
          ),
        ),
      ],
    );
  }

  Widget normalNewsList(List articles) {
    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No General News Available",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return NewsCard(article: article); // Use NewsCard consistently
      });
      }
  }


class DataSearch extends SearchDelegate<String> {
  final List<Article> articles; // Pass the list of articles
  final List<String> recentArticles = [
    "Recent Article 1",
  ];

  DataSearch(this.articles); // Constructor to accept articles

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = articles.where((article) => article.title.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetails(article: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentArticles
        : articles.where((article) => article.title.toLowerCase().startsWith(query.toLowerCase())).map((article) => article.title).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
        );
      },
    );
  }
}
