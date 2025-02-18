import 'dart:convert';
import 'dart:io';

import 'package:apyar/app/constants.dart';
import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:flutter/material.dart';

Future<List<BookmarkModel>> getBookmarkList() async {
  List<BookmarkModel> list = [];
  try {
    final file = File('${getLibaryPath()}/$appBookmarkFileName');
    if (file.existsSync()) {
      final List<dynamic> resList = jsonDecode(file.readAsStringSync());
      list = resList.map((map) => BookmarkModel.fromMap(map)).toList();
    }
  } catch (e) {
    debugPrint('getBookmarkList: ${e.toString()}');
  }
  return list;
}

Future<void> setBookmarkList({required List<BookmarkModel> list}) async {
  try {
    final file = File('${getLibaryPath()}/$appBookmarkFileName');
    final mapList = list.map((bm) => bm.toMap()).toList();
    final json = JsonEncoder.withIndent(' ').convert(mapList);
    await file.writeAsString(json);
  } catch (e) {
    debugPrint('setBookmarkList: ${e.toString()}');
  }
}
