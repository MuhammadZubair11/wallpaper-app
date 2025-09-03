import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:wallpaperapp/view_models/walpaper_viewmodel.dart';
import 'package:wallpaperapp/views/walpaper_detail.dart';

class WallpaperGrid extends StatefulWidget {
  const WallpaperGrid({super.key});

  @override
  State<WallpaperGrid> createState() => _WallpaperGridState();
}

class _WallpaperGridState extends State<WallpaperGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initial fetch
    Future.microtask(() {
      Provider.of<WallpaperViewModel>(
        context,
        listen: false,
      ).fetchWallpapers(loadMore: false);
    });

    // Infinite scroll listener
    _scrollController.addListener(() {
      final viewModel = Provider.of<WallpaperViewModel>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !viewModel.isLoading &&
          viewModel.hasMore) {
        viewModel.fetchWallpapers(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildShimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WallpaperViewModel>(
      builder: (context, viewModel, child) {
        // Initial loading
        if (viewModel.isLoading && viewModel.wallpapers.isEmpty) {
          return Stack(
            children: [
              StaggeredGridView.countBuilder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                itemCount: 6,
                itemBuilder: (context, index) => _buildShimmerTile(),
                staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ],
          );
        }

        // Empty state
        if (viewModel.wallpapers.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.35),
              Center(
                child: Text(
                  viewModel.hasInternet
                      ? 'No Wallpapers Found!'
                      : 'Internet Connection Error. Pull to refresh.',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }

        // Main Grid
        return Column(
          children: [
            Expanded(
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                itemCount: viewModel.wallpapers.length,
                itemBuilder: (context, index) {
                  final wallpaper = viewModel.wallpapers[index];
                  final imageSrc = wallpaper['src'];
                  final imageUrl =
                      imageSrc['large2x'] ??
                      imageSrc['large'] ??
                      imageSrc['original'] ??
                      imageSrc['portrait'] ??
                      imageSrc['landscape'] ??
                      imageSrc['medium'] ??
                      imageSrc['tiny'];

                  final width = wallpaper['width'] ?? 1080;
                  final height = wallpaper['height'] ?? 1920;
                  final aspectRatio = width / height;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WallpaperDetailScreen(
                            imageUrl: imageUrl,
                            heroTag: 'wallpaper_$index',
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'wallpaper_$index',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: aspectRatio,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildShimmerTile(),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
              ),
            ),

            // Load More indicator
            if (viewModel.isLoading && viewModel.wallpapers.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}
