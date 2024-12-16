import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/article.dart';
import 'package:insight_today/screens/article_details.dart';
import '../controllers/bookmark_controller.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final BookmarkController _bookmarkController = Get.find();

  NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to ArticleDetails
          Get.to(() => ArticleDetails(article: article));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              if (article.urlToImage.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    article.urlToImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      article.description,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[800] // Dark grey for light mode
                            : Colors.grey[400], // Light grey for dark mode
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Published Date
                    Text(
                      'Published: ${article.publishedAt}',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Bookmark and Read More Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bookmark Icon
                        Obx(() {
                          final isBookmarked = _bookmarkController.isBookmarked(article);
                          return GestureDetector(
                            onTap: () {
                              if (isBookmarked) {
                                _bookmarkController.removeBookmark(article);
                              } else {
                                _bookmarkController.addBookmark(article);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: isBookmarked ? Colors.red : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isBookmarked ? 'Bookmarked' : 'Bookmark',
                                  style: TextStyle(
                                    color: isBookmarked ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        // Read More Button
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ArticleDetails(article: article));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Read More',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}