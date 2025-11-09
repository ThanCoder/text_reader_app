import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg/services/t_map.dart';

class ReaderConfig {
  double fontSize;
  double paddingX;
  double paddingY;
  bool isKeepScreening;
  ReaderConfig({
    required this.fontSize,
    required this.paddingX,
    required this.paddingY,
    required this.isKeepScreening,
  });

  factory ReaderConfig.create({
    double fontSize = 18,
    double paddingX = 2,
    double paddingY = 5,
    bool isKeepScreening = false,
  }) {
    return ReaderConfig(
      fontSize: fontSize,
      paddingX: paddingX,
      paddingY: paddingY,
      isKeepScreening: isKeepScreening,
    );
  }
  // path
  factory ReaderConfig.fromPath(String path) {
    final file = File(path);
    if (file.existsSync()) {
      try {
        final json = jsonDecode(file.readAsStringSync());
        return ReaderConfig.fromMap(json);
      } catch (e) {
        debugPrint('[ReaderConfig.fromPath]: ${e.toString()}');
      }
    }
    return ReaderConfig.create();
  }
  Future<void> savePath(String path) async {
    try {
      final file = File(path);
      final contents = JsonEncoder.withIndent(' ').convert(toMap());
      await file.writeAsString(contents);
    } catch (e) {
      debugPrint('[ReaderConfig:savePath]: ${e.toString()}');
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontSize': fontSize,
      'paddingX': paddingX,
      'paddingY': paddingY,
      'isKeepScreening': isKeepScreening,
    };
  }

  factory ReaderConfig.fromMap(Map<String, dynamic> map) {
    return ReaderConfig(
      fontSize: map.getDouble(['fontSize'], def: 18),
      paddingX: map.getDouble(['paddingX'], def: 2),
      paddingY: map.getDouble(['paddingY'], def: 5),
      isKeepScreening: map.getBool(['isKeepScreening'], def: false),
    );
  }
}
