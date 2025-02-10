import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.json');
  }

  static Future<void> saveData(String key, List<dynamic> data) async {
    final file = await _getFile(key);
    await file.writeAsString(jsonEncode(data));
  }

  static Future<List<dynamic>> getData(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsString();
      return jsonDecode(contents) as List;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> isOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }
}