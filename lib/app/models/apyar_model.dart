// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:apyar/app/utils/index.dart';

class ApyarModel {
  String title;
  String path;
  String genres;
  String desc;
  int date;

  late String coverPath;
  ApyarModel({
    this.title = 'Untitled',
    this.path = '',
    this.genres = '',
    this.desc = '',
    required this.date,
  }) {
    coverPath = '$path/cover.png';
  }

  factory ApyarModel.fromPath(String path) {
    final file = File(path);
    return ApyarModel(
      title: getBasename(path),
      path: path,
      date: file.statSync().modified.millisecondsSinceEpoch,
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
  String toString() {
    return '\ntitle => $title\n';
  }
}
