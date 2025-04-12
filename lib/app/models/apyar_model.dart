import 'dart:io';

import 'package:apyar/app/extensions/index.dart';
import 'package:apyar/app/text_reader/text_reader_data_interface.dart';
import 'package:apyar/app/utils/path_util.dart';

class ApyarModel implements TextReaderDataInterface<ApyarModel> {
  String title;
  String path;
  String genres;
  String desc;
  int date;
  int number;

  late String coverPath;
  ApyarModel({
    required this.date,
    this.title = 'Untitled',
    this.path = '',
    this.genres = '',
    this.desc = '',
    this.number = 1,
  }) {
    coverPath = '$path/cover.png';
  }

  factory ApyarModel.fromPath(String path, {int number = 1}) {
    final dir = Directory(path.trim());
    String title = dir.path.getName();

    return ApyarModel(
      title: title,
      path: path,
      number: number,
      date: dir.statSync().modified.millisecondsSinceEpoch,
    );
  }

  factory ApyarModel.create(String title) {
    final dir =
        Directory('${PathUtil.instance.getSourcePath()}/${title.trim()}');
    if (dir.existsSync()) throw Exception('`already exists: ${dir.path}`');
    dir.createSync();

    return ApyarModel.fromPath(dir.path);
  }

  Future<void> delete() async {
    final oldDir = Directory(path);
    if (await oldDir.exists()) {
      await oldDir.delete(recursive: true);
    }
  }

  Future<String> updateTitle(String title) async {
    final newDir =
        Directory('${PathUtil.instance.getSourcePath()}/${title.trim()}');
    final oldDir = Directory(path);
    //mkdir
    await newDir.create();
    //move
    for (var file in oldDir.listSync()) {
      await file.rename('${newDir.path}/${file.getName()}');
    }
    await oldDir.delete(recursive: true);
    return newDir.path;
  }

  factory ApyarModel.fromMap(Map<String, dynamic> map) {
    return ApyarModel(
      title: map['title'],
      path: map['path'],
      genres: map['genres'],
      desc: map['desc'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'path': path,
        'genres': genres,
        'desc': desc,
        'date': date,
      };

  String getNumberContent(int apyarNumber) {
    final file = File('$path/$apyarNumber');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }

  void deleteNumber(int apyarNumber) {
    final file = File('$path/$apyarNumber');
    if (!file.existsSync()) return;
    file.deleteSync();
  }

  String getNumberPath(int apyarNumber) {
    return '$path/$apyarNumber';
  }

  void saveNumberContent(int apyarNumber, String content) {
    final file = File('$path/$apyarNumber');
    file.writeAsStringSync(content);
  }

  @override
  String getContent() {
    final file = File('$path/$number');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }

  String getChapterTitle() {
    final dir = Directory(path);
    String title = dir.path.getName();
    final ch = File('$path/$number');
    if (ch.existsSync()) {
      final lines = ch.readAsLinesSync();
      if (lines.isNotEmpty) {
        if (lines.first.isNotEmpty) {
          title = lines.first;
        }
      }
    }
    return title;
  }

  @override
  bool isExistNext() {
    final file = File('$path/${number + 1}');
    return file.existsSync();
  }

  @override
  bool isExistsPrev() {
    final file = File('$path/${number - 1}');
    return file.existsSync();
  }

  @override
  ApyarModel getNext() {
    return ApyarModel.fromPath(path, number: number + 1);
  }

  @override
  ApyarModel getPrev() {
    return ApyarModel.fromPath(path, number: number - 1);
  }

  @override
  String toString() {
    return title;
  }
}
