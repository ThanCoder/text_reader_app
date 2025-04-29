import 'dart:convert';
import 'dart:io';

import 'package:apyar/app/utils/index.dart';

import 'types/scraper_content_data_model.dart';

class ScraperBookmarkServices {
  static Future<void> addDataList(
    String title, {
    required List<ScraperContentDataModel> list,
  }) async {
    final file = File(getPath);
    var map = {};
    if (file.existsSync()) {
      map = jsonDecode(file.readAsStringSync());
    }
    map[title] = list.map((cd) => cd.toMap).toList();
    //save
    file.writeAsStringSync(jsonEncode(map));
  }

  static Future<void> removeTitle(String title) async {
    final file = File(getPath);
    if (file.existsSync()) {
      Map<String, dynamic> map = jsonDecode(file.readAsStringSync());
      map.remove(title);

      //save
      file.writeAsStringSync(jsonEncode(map));
    }
  }

  static Future<List<String>> getTitleList() async {
    final file = File(getPath);
    if (file.existsSync()) {
      Map<String, dynamic> map = jsonDecode(file.readAsStringSync());
      return map.keys.toList();
    }
    return [];
  }

  static Future<List<ScraperContentDataModel>> getDataList({
    required String title,
  }) async {
    final file = File(getPath);
    if (file.existsSync()) {
      final map = jsonDecode(file.readAsStringSync());
      List<dynamic> mapList = map[title] ?? [];
      return mapList
          .map((map) => ScraperContentDataModel.fromMap(map))
          .toList();
    }
    return [];
  }

  static get getPath {
    return '${PathUtil.getLibaryPath()}/scraper-bookmark.json';
  }
}
