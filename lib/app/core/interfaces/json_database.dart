import 'dart:convert';

import 'package:text_reader/app/core/interfaces/data_io.dart';
import 'package:text_reader/app/core/interfaces/database.dart';

abstract class JsonDatabase<T> extends Database<T> {
  String dbPath;
  DataIO io;
  JsonDatabase({required this.dbPath, required super.fileStorage})
    : io = JsonIO.instance;

  T from(Map<String, dynamic> map);
  Map<String, dynamic> to(T value);

  @override
  Future<List<T>> getAll() async {
    final source = await io.read(dbPath);
    if (source.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(source);
    return jsonList.map((e) => from(e)).toList();
  }

  @override
  Future<void> add(T value) async {
    final list = await getAll();
    list.add(value);
    await save(list);
  }

  Future<void> save(List<T> list, {bool isPretty = true}) async {
    final jsonList = list.map((e) => to(e)).toList();
    await io.write(
      dbPath,
      isPretty
          ? JsonEncoder.withIndent(' ').convert(jsonList)
          : jsonEncode(jsonList),
    );
  }
}
