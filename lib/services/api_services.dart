import 'dart:convert';
import 'package:http/http.dart' as http;

// fetch api images ka liya
class ApiServices {
  static const String apiKey =
      "nUhqr0IOsaHqbDsIX2HXWVLR4Z0ATvHj2wvnjGfzDap9kSPmzc0LAMPi";
  static String baseUrl = "https://api.pexels.com/v1/search";

  Future<List<dynamic>> fetchWallpapers({
    required String query,
    // paginations
    int page = 1,

    int perPage = 15,
  }) async {
    final url = Uri.parse('$baseUrl?query=$query&page=$page&per_page=$perPage');

    final response = await http.get(url, headers: {'Authorization': apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['photos'] ?? [];
    } else {
      throw Exception('Wallpaper fetch error: ${response.statusCode}');
    }
  }
}
