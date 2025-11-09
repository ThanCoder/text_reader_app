import 'dart:io';

import 'package:than_pkg/extensions/file_system_entity_extension.dart';
import 'package:than_pkg/services/t_map.dart';
import 'package:uuid/uuid.dart';

class Post {
  int indexId;
  String id;
  String title;
  String tags;
  String body;
  DateTime date;

  Post({
    required this.id,
    required this.indexId,
    required this.title,
    required this.tags,
    required this.body,
    required this.date,
  });

  factory Post.create({
    required int indexId,
    String? id,
    String title = 'Untitled',
    String tags = '',
    String body = '',
    DateTime? date,
  }) {
    return Post(
      indexId: indexId,
      id: id ?? Uuid().v4(),
      title: title,
      tags: tags,
      body: body,
      date: date ?? DateTime.now(),
    );
  }

  Post copyWith({
    String? id,
    int? indexId,
    String? title,
    String? tags,
    String? body,
    DateTime? date,
  }) {
    return Post(
      indexId: indexId ?? this.indexId,
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      body: body ?? this.body,
      date: date ?? this.date,
    );
  }

  factory Post.fromPath(String path, {int indexId = 0}) {
    final file = File(path);
    return Post(
      indexId: indexId,
      id: file.getName(),
      title: file.getName(),
      tags: '',
      body: '',
      date: file.statSync().modified,
    );
  }

  // map
  Map<String, dynamic> toMap() => {
    'indexId': indexId,
    'id': id,
    'title': title,
    'tags': tags,
    'body': body,
    'date': date.millisecondsSinceEpoch,
  };
  factory Post.fromMap(Map<String, dynamic> map) {
    int dateInt = map['date'];
    return Post(
      indexId: map.getInt(['indexId']),
      id: map['id'],
      title: map['title'],
      tags: map['tags'],
      body: map['body'],
      date: DateTime.fromMillisecondsSinceEpoch(dateInt),
    );
  }

  String get getCoverPath {
    return '/$id.png';
  }

  String get getBody {
    final file = File('/$id.body');
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return '';
  }

  void setBody(String text) {
    final file = File('/$id.body');
    file.writeAsStringSync(text);
  }

  void delete() {
    // delete
    final file = File('/$id.body');
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  void newDate() {
    date = DateTime.now();
  }

  List<String> get getTags {
    final list = tags.split(',').where((e) => e.isNotEmpty).toList();
    return list;
  }

  void setTags(List<String> list) {
    tags = list.join(',');
  }

  @override
  String toString() {
    return title;
  }
}
