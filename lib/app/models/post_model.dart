// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:text_reader/other_libs/setting_v2.0.0/setting.dart';
import 'package:uuid/uuid.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class PostModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String tags;
  @HiveField(3)
  String body;
  @HiveField(4)
  DateTime date;

  PostModel({
    required this.id,
    required this.title,
    required this.tags,
    required this.body,
    required this.date,
  });

  factory PostModel.create({
    String title = 'Untitled',
    String tags = '',
    String body = '',
  }) {
    return PostModel(
      id: Uuid().v4(),
      title: title,
      tags: tags,
      body: body,
      date: DateTime.now(),
    );
  }
  String get getCoverPath {
    return '${PathUtil.getDatabaseSourcePath()}/$id.png';
  }

  String get getBody {
    final file = File('${PathUtil.getDatabaseSourcePath()}/$id.body');
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return '';
  }

  void setBody(String text) {
    final file = File('${PathUtil.getDatabaseSourcePath()}/$id.body');
    file.writeAsStringSync(text);
  }

  void delete() {
    getBox.delete(id);
    // delete
    final file = File('${PathUtil.getDatabaseSourcePath()}/$id.body');
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  void newDate() {
    date = DateTime.now();
  }

  @override
  String toString() {
    return title;
  }

  // static
  static String dbName = 'post';

  static Box<PostModel> get getBox {
    return Hive.box<PostModel>(dbName);
  }
}
