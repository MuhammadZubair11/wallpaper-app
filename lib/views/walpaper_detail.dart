import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/custome_widgets/animated_back.dart';

class WallpaperDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const WallpaperDetailScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  // Wallpaper set function
  Future<void> _setWallpaper(BuildContext context) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      showSnack(context, 'Storage permission denied');
      return;
    }

    File file;
    try {
      file = await DefaultCacheManager().getSingleFile(imageUrl);
    } catch (e) {
      showSnack(context, 'Download failed: $e');
      return;
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        // used container
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text(
                      'Home Screen',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      applyWallpaper(
                        context,
                        file.path,
                        WallpaperManagerPlus.homeScreen,
                      );
                    },
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.white),
                    title: Text(
                      'Lock Screen',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      applyWallpaper(
                        context,
                        file.path,
                        WallpaperManagerPlus.lockScreen,
                      );
                    },
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: const Icon(
                      Icons.phone_android,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Both Screens',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      applyWallpaper(
                        context,
                        file.path,
                        WallpaperManagerPlus.bothScreens,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> applyWallpaper(
    BuildContext context,
    String filePath,
    int location,
  ) async {
    try {
      final File file = File(filePath);
      if (!await file.exists()) {
        showSnack(context, 'File does not exist!');
        return;
      }

      final String? result = await WallpaperManagerPlus().setWallpaper(
        file,
        location,
      );
      if (result != null && result.isNotEmpty) {
        showSnack(context, 'Wallpaper set successfully!');
      } else {
        showSnack(context, 'Failed to set wallpaper');
      }
    } catch (e) {
      showSnack(context, 'Error: $e');
    }
  }

  // Save image to gallery
  Future<void> saveImageToGallery(BuildContext context) async {
    bool granted;
    if (Platform.isAndroid) {
      granted =
          (await Permission.photos.request()).isGranted ||
          (await Permission.storage.request()).isGranted;
    } else {
      granted = await Permission.photosAddOnly.request().isGranted;
    }

    if (!granted) {
      showSnack(context, 'Permission denied');
      return;
    }

    try {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = Uint8List.fromList(response.bodyBytes);

      final result = await SaverGallery.saveImage(
        bytes,
        fileName: "wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg",
        quality: 100,
        androidRelativePath: "Pictures/WallpaperApp",
        skipIfExists: false,
      );

      if (result.isSuccess == true) {
        showSnack(context, 'Image saved to gallery!');
      } else {
        showSnack(context, 'Failed to save image.');
      }
    } catch (e) {
      showSnack(context, 'Error: $e');
    }
  }

  void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ya wiget new banaya ha glassbutton ka jo ka filkter hoga
  Widget glassButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 50,
  }) {
    return ClipRRect(
      // filter kr ka
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StarBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Hero(
              tag: heroTag,
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
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
            // Back button
            Positioned(
              top: 40,
              left: 20,
              child: glassButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            // Download button (top-right)
            Positioned(
              top: 40,
              right: 20,
              child: glassButton(
                icon: Icons.download,
                onTap: () => saveImageToGallery(context),
              ),
            ),
            // Set as Wallpaper button
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.white.withOpacity(0.4)),
                      ),
                    ),
                    onPressed: () => _setWallpaper(context),
                    child: const Text(
                      "Set as Wallpaper",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
