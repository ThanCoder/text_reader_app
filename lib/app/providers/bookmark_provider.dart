import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/services/bookmark_services.dart';
import 'package:flutter/material.dart';

class BookmarkProvider with ChangeNotifier {
  final List<ApyarModel> _list = [];
  bool _isLoading = false;
  ApyarModel? _apyar;

  List<ApyarModel> get getList => _list;
  ApyarModel? get getCurrent => _apyar;

  bool get isLoading => _isLoading;

  Future<void> initList({bool isReset = false}) async {
    try {
      if (isReset == false && _list.isNotEmpty) {
        return;
      }
      _isLoading = true;
      notifyListeners();

      final res = await BookmarkServices.getList();

      _list.clear();
      _list.addAll(res);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> toggle(ApyarModel apyar) async {
    if (await isExists(apyar)) {
      await remove(apyar);
    } else {
      await add(apyar);
    }
  }

  Future<bool> isExists(ApyarModel apyar) async {
    final res = _list.where((ap) => ap.title == apyar.title);
    if (res.isNotEmpty) return true;
    return false;
  }

  Future<void> add(ApyarModel apyar) async {
    _list.insert(0, apyar);
    BookmarkServices.setList(_list);
    notifyListeners();
  }

  Future<void> remove(ApyarModel apyar) async {
    final res = _list.where((ap) => ap.title != apyar.title).toList();
    _list.clear();
    _list.addAll(res);
    BookmarkServices.setList(_list);
    notifyListeners();
  }
}
