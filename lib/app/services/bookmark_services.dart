import 'dart:convert';
import 'dart:io';

import 'package:apyar/app/constants.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/utils/path_util.dart';
import 'package:flutter/material.dart';

class BookmarkServices {
  static Future<void> setList(List<ApyarModel> list) async {
    final file = File(getDBPath);
    final strPath = list.map((ap) => ap.title).toList();
    await file.writeAsString(jsonEncode(strPath));
  }

  static Future<List<ApyarModel>> getList() async {
    try {
      List<ApyarModel> list = [];
      final file = File(getDBPath);
      if (!await file.exists()) return [];

      List<dynamic> resList = jsonDecode(await file.readAsString());
      list = resList
          .map((name) => ApyarModel.fromPath(_getSourcePath(name)))
          .toList();
      return list;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  static String _getSourcePath(String name) {
    return '${PathUtil.instance.getSourcePath()}/$name';
  }

  static String get getDBPath =>
      '${PathUtil.instance.getLibaryPath()}/$appBookmarkFileName';
}
