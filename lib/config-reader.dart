import 'dart:convert';
import 'package:flutter/services.dart';

class ConfigReader {

  static Map<String, dynamic> _config = {};


  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getImgurApiKey() {
    return _config['imgur-key'] as String;
  }
}