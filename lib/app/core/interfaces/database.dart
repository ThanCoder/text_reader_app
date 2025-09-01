import 'package:text_reader/app/core/interfaces/database_listener.dart';
import 'package:text_reader/app/core/interfaces/file_storage.dart';

abstract class Database<T> {
  FileStorage fileStorage;
  String root;
  Database({required this.fileStorage, required this.root});
  Future<List<T>> getAll();
  Future<void> add(T value);
  Future<void> update(T value);
  Future<void> delete(T value);

  // listener
  final List<DatabaseListener> _listener = [];

  void addListener(DatabaseListener eve) {
    _listener.add(eve);
  }

  void removeListener(DatabaseListener eve) {
    _listener.remove(eve);
  }

  void clearListener() {
    _listener.clear();
  }

  void notify() {
    for (var eve in _listener) {
      eve.onDatabaseChanged();
    }
  }
}
