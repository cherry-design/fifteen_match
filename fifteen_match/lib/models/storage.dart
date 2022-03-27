import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

/// Storage model
class Storage {
  /// Load collections from JSON file
  static Future<List<Collection>> loadCollections() async {
    var jsonString = await rootBundle.loadString('assets/collections.json');
    var json = jsonDecode(jsonString);
    List<Collection> collections = (json['collections'] as List<dynamic>)
        .map((collection) =>
            Collection.fromJson(collection as Map<String, dynamic>))
        .toList();
    return collections;
  }

  /// Load copyrights from text file
  static Future<String> loadCopyrights() async {
    var copyrights = await rootBundle.loadString('assets/music/copyrights.txt');
    return copyrights;
  }
}
