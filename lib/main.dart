import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/article_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/bookmark_controller.dart'; // Ensure this import is correct
import 'screens/landing_page.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize controllers
  Get.put(ArticleController());
  Get.put(ThemeController());
  Get.put(BookmarkController()); // Ensure this is added

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InsightToday',
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const LandingPage(),
    ));
  }
}