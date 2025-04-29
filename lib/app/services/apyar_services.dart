import 'dart:io';
import 'dart:isolate';

import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:flutter/material.dart';

class ApyarServices {
  static final ApyarServices instance = ApyarServices._();
  ApyarServices._();
  factory ApyarServices() => instance;

  Future<List<ApyarModel>> getList() async {
    final path = PathUtil.getSourcePath();
    return await Isolate.run<List<ApyarModel>>(() async {
      try {
        List<ApyarModel> list = [];
        final dir = Directory(path);
        if (!await dir.exists()) return [];
        for (var file in dir.listSync()) {
          if (file.statSync().type != FileSystemEntityType.directory) continue;
          list.add(ApyarModel.fromPath(file.path));
        }
        //sort
        list.sort((a, b) {
          if (a.date > b.date) return -1;
          if (a.date < b.date) return 1;
          return 0;
        });

        return list;
      } catch (e) {
        debugPrint(e.toString());
      }

      return [];
    });
  }
}
