import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:apyar/app/enums/isolate_return_types.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:flutter/material.dart';

Future<List<ApyarModel>> getApyarListIsolate() async {
  final completer = Completer<List<ApyarModel>>();
  try {
    final dir = Directory(getSourcePath());

    final list = await Isolate.run<List<ApyarModel>>(() {
      List<ApyarModel> list = [];
      for (var file in dir.listSync()) {
        //skip
        if (file.statSync().type != FileSystemEntityType.directory) continue;
        //dir
        final apyar = ApyarModel(
          title: getBasename(file.path),
          path: file.path,
          date: file.statSync().modified.millisecondsSinceEpoch,
        );
        list.add(apyar);
      }

      //sort latest data
      list.sort((a, b) => a.date.compareTo(b.date));
      return list;
    });

    completer.complete(list);

    // await Isolate.spawn(_getApyarList, [receivePort.sendPort, getSourcePath()]);
    // receivePort.listen((data) {
    //   if (data is Map) {
    //     final type = data['type'] as IsolateReturnTypes;
    //     if (type == IsolateReturnTypes.success) {
    //       final mapList = data['msg'] as List<dynamic>;
    //       final list = mapList.map((map) => ApyarModel.fromMap(map)).toList();
    //       completer.complete(list);
    //       receivePort.close();
    //     }
    //     if (type == IsolateReturnTypes.error) {
    //       completer.completeError(data['msg']);
    //       receivePort.close();
    //     }
    //   }
    // });
  } catch (e) {
    debugPrint('getApyarList: ${e.toString()}');
  }
  return completer.future;
}

//isolate
void _getApyarList(List<Object> args) async {
  try {
    final sendPort = args[0] as SendPort;
    final sourcePath = args[1] as String;
    final dir = Directory(sourcePath);
    if (!await dir.exists()) {
      sendPort
          .send({'type': IsolateReturnTypes.error, 'msg': 'dir not exists'});
      return;
    }
    List<ApyarModel> list = [];
    for (var file in dir.listSync()) {
      //skip
      if (file.statSync().type != FileSystemEntityType.directory) continue;
      //dir
      final apyar = ApyarModel(
        title: getBasename(file.path),
        path: file.path,
        date: file.statSync().modified.millisecondsSinceEpoch,
      );
      list.add(apyar);
    }

    //sort latest data
    list.sort((a, b) => a.date.compareTo(b.date));

    //to map
    final data = list.map((ap) => ap.toMap()).toList();

    //send main
    sendPort
        .send({'type': IsolateReturnTypes.success, 'list': jsonEncode(data)});
  } catch (e) {
    debugPrint('@Isolate:_getApyarList: ${e.toString()}');
  }
}
