import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableProvider extends ChangeNotifier {
  // dynamic list
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    // shared prefernece ma data da ve hoga
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('cached_users');

    // local data laod hoga
    if (savedData != null) {
      final List<dynamic> localList = jsonDecode(savedData);
      _users = localList.cast<Map<String, dynamic>>();
      _isLoading = false;
      notifyListeners();
    }

    // api
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/users?limit=100"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        _users = (decoded['users'] as List).cast<Map<String, dynamic>>();
        // api wala data local ma save hoga
        await prefs.setString('cached_users', jsonEncode(_users));
      }
    } catch (e) {
      debugPrint("API fetch failed: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void deleteUser(int index) {
    _users.removeAt(index);
    saveToLocal();
    notifyListeners();
  }

  void updateUser(int index, String newName, String newEmail) {
    final parts = newName.split(" ");
    _users[index]['firstName'] = parts.first;
    _users[index]['lastName'] = parts.length > 1
        ? parts.sublist(1).join(" ")
        : '';
    _users[index]['email'] = newEmail;
    saveToLocal();
    notifyListeners();
  }

  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_users', jsonEncode(_users));
  }
}
