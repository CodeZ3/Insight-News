import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bookmark_controller.dart';
import '../widgets/news_card.dart';

class BookmarksScreen extends StatelessWidget {
  final BookmarkController bookmarkController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              Get.defaultDialog(
                title: 'Clear Bookmarks',
                content: Text('Are you sure you want to remove all bookmarks?'),
                textConfirm: 'Clear',
                textCancel: 'Cancel',
                onConfirm: () {
                  bookmarkController.clearBookmarks();
                  Get.back();
                },
              );
            },
          )
        ],
      ),
      body: Obx(() {
        if (bookmarkController.bookmarkedArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'No Bookmarks',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Bookmark articles to read later',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: bookmarkController.bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = bookmarkController.bookmarkedArticles[index];
            return NewsCard(article: article);
          },
        );
      }),
    );
  }
}