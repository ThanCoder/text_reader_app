// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:than_pkg/than_pkg.dart';
import 'package:text_reader/app/core/types/database_types.dart';

class Bookmark {
  String id;
  String title;
  DatabaseTypes databaseType;
  Bookmark({required this.id, required this.title, required this.databaseType});

  factory Bookmark.create({
    String? id,
    String? title,
    DatabaseTypes? databaseType,
  }) {
    return Bookmark(
      id: id ?? 'Untitled',
      title: title ?? 'Untitled',
      databaseType: databaseType ?? DatabaseTypes.folder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'databaseType': databaseType.name,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    final databaseTypeStr = map.getString(['databaseType']);
    return Bookmark(
      id: map.getString(['id']),
      title: map.getString(['title']),
      databaseType: DatabaseTypes.getType(databaseTypeStr),
    );
  }
}
