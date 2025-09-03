import 'package:flutter/material.dart';
import 'package:wallpaperapp/services/api_services.dart';

class WallpaperViewModel extends ChangeNotifier {
  // call api
  final ApiServices apiServices = ApiServices();
  // or data ka model ha sara
  // pagiantion ka pages ha y
  int page = 1;
  int perPage = 10;
  String currentQuery = 'Any';
  List<dynamic> wallpapers = [];
  bool isLoading = false;
  bool hasMore = true;
  bool hasInternet = true;
  // ya function ab bana ga jo ka api ko call kra ga
  Future<void> fetchWallpapers({
    String? query,
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (isLoading) return;

    // Update query
    if (query != null) {
      currentQuery = query;
    }

    if (refresh || !loadMore) {
      page = 1;
      wallpapers.clear();
      hasMore = true;
      notifyListeners();
    }

    isLoading = true;
    notifyListeners();

    try {
      final newWallpapers = await apiServices.fetchWallpapers(
        query: currentQuery,
        page: page,
        perPage: perPage,
      );

      if (newWallpapers.isNotEmpty) {
        wallpapers.addAll(newWallpapers);
        page++;
      } else {
        hasMore = false;
      }

      hasInternet = true;
    } catch (e) {
      debugPrint('Error fetching wallpapers: $e');
      hasInternet = false;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshWallpapers() async {
    await fetchWallpapers(query: currentQuery, refresh: true);
  }
}
