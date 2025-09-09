import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wallpaperapp/practice_new.dart/model_table.dart';
import 'package:wallpaperapp/view_models/catogries_view%20model.dart';
import 'package:wallpaperapp/view_models/walpaper_viewmodel.dart';

import 'package:wallpaperapp/views/splahscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // multiprovider learn new
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperViewModel()),
        ChangeNotifierProvider(create: (_) => ChipSelectionProvider()),
        ChangeNotifierProvider(create: (_) => TableProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallPaper App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
