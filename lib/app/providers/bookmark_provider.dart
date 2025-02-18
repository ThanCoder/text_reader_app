import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/services/index.dart';
import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  final List<BookmarkModel> _list = [];
  bool _isLoading = false;
  bool _isExists = false;

  List<BookmarkModel> get getList => _list;
  bool get isLoading => _isLoading;
  bool get isExists => _isExists;

  Future<void> initList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await getBookmarkList();

      _list.clear();
      _list.addAll(res);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> toggle({required String apyarTitle}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final res = _list.where((bm) => bm.title == apyarTitle).toList();
      if (res.isEmpty) {
        //add
        _list.insert(0, BookmarkModel(title: apyarTitle));
      } else {
        //delete
        final delResult = _list.where((bm) => bm.title != apyarTitle).toList();
        _list.clear();
        _list.addAll(delResult);
      }
      //save bookmark
      setBookmarkList(list: _list);

      _isLoading = false;
      notifyListeners();

      //check
      checkExists(apyarTitle: apyarTitle);
    } catch (e) {
      debugPrint('toggle: ${e.toString()}');
    }
  }

  void checkExists({required String apyarTitle}) {
    final res = _list.where((bm) => bm.title == apyarTitle).toList();
    if (res.isEmpty) {
      _isExists = false;
    } else {
      _isExists = true;
    }
    notifyListeners();
  }
}
