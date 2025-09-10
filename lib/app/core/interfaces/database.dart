// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'storage.dart';

abstract class Database<T> {
  final String root;
  final Storage storage;
  Database({required this.root, required this.storage});

  Future<List<T>> getAll();
  Future<void> add(T value);
  Future<void> update(String id, T value);
  Future<void> delete(String id);
  // listener
  static final List<DatabaseListener> _listener = [];
  void addListener(DatabaseListener listener) {
    _listener.add(listener);
  }

  void removeListener(DatabaseListener listener) {
    _listener.remove(listener);
  }

  void clearListener() {
    _listener.clear();
  }

  void notify() {
    for (var ev in _listener) {
      ev.onDatabaseChanged();
    }
  }
}

mixin DatabaseListener {
  void onDatabaseChanged();
}
