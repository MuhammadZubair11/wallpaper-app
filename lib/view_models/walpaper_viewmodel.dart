import 'package:flutter/material.dart';
import 'package:wallpaperapp/services/api_services.dart';

class WallpaperViewModel extends ChangeNotifier {
  // call api
  final ApiServices apiServices = ApiServices();

  int page = 1;
  int perPage = 10;
  String currentQuery = 'Any';

  List<dynamic> wallpapers = [];
  bool isLoading = false;
  bool hasMore = true;
  bool hasInternet = true;

  Future<void> fetchWallpapers({
    String? query,
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (isLoading) return;

    // Update query only if provided
    if (query != null) {
      currentQuery = query;
    }

    // Reset when refresh or not loading more
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
        page++; // <<< this will now work with correct query
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
