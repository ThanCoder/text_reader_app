import 'dart:io';

import 'package:apyar/app/extensions/index.dart';
import 'package:apyar/app/text_reader/text_reader_data_interface.dart';

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

  factory ApyarModel.fromPath(String path) {
    final dir = Directory(path.trim());
    String title = dir.path.getName();

    return ApyarModel(
      title: title,
      path: path,
      date: dir.statSync().modified.millisecondsSinceEpoch,
    );
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
    return ApyarModel.fromPath('$path/${number + 1}');
  }

  @override
  ApyarModel getPrev() {
    return ApyarModel.fromPath('$path/${number - 1}');
  }

  @override
  String toString() {
    return title;
  }
}
