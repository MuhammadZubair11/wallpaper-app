import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/custome_widgets/animated_back.dart';
import 'package:wallpaperapp/custome_widgets/categories_list.dart';
import 'package:wallpaperapp/custome_widgets/searchbar.dart';
import 'package:wallpaperapp/custome_widgets/walpapergrid.dart';
import 'package:wallpaperapp/view_models/walpaper_viewmodel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = [
    'Any',
    'Nature',
    'Technology',
    'Animals',
    'Space',
    'Cars',
    'Art',
    'Bike',
    'Cartoon',
    'Auto',
  ];
  // jis type ki category ho gi

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // call provider
      Provider.of<WallpaperViewModel>(context, listen: false).fetchWallpapers();
    });
  }

  // seach wala function
  void onSearch(String query) {
    // query agr empty hogi to
    if (query.isNotEmpty) {
      Provider.of<WallpaperViewModel>(
        context,
        listen: false,
      ).fetchWallpapers(query: query);
    }
  }

  // catogry wala function
  void onCategory(String category) {
    Provider.of<WallpaperViewModel>(
      context,
      listen: false,
    ).fetchWallpapers(query: category);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: StarBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Wallpaper App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              CustomSearchBar(
                controller: searchController,
                onClear: () {
                  searchController.clear();
                  Provider.of<WallpaperViewModel>(
                    context,
                    listen: false,
                  ).fetchWallpapers();
                },
                onSearch: onSearch,
              ),

              // Categories
              CategoryList(categories: categories, onTap: onCategory),

              // Wallpapers Grid
              Expanded(child: WallpaperGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
