import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/services/apyar_services.dart';
import 'package:flutter/material.dart';

class ApyarProvider with ChangeNotifier {
  final List<ApyarModel> _list = [];
  bool _isLoading = false;
  ApyarModel? _apyar;

  List<ApyarModel> get getList => _list;
  ApyarModel? get getCurrent => _apyar;

  bool get isLoading => _isLoading;

  Future<void> initList({
    bool isReset = false,
    bool showLoading = true,
  }) async {
    try {
      if (isReset == false && _list.isNotEmpty) {
        return;
      }
      if (showLoading) {
        _isLoading = true;
      }
      notifyListeners();

      final res = await ApyarServices.instance.getList();

      _list.clear();
      _list.addAll(res);

      if (showLoading) {
        _isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> setCurrent(ApyarModel apyar) async {
    _apyar = apyar;
    notifyListeners();
  }

  Future<void> add(ApyarModel apyar) async {
    _list.add(apyar);
    notifyListeners();
  }

  Future<void> insert(ApyarModel apyar) async {
    _list.insert(0, apyar);
    notifyListeners();
  }

  Future<void> remove(ApyarModel apyar) async {
    final res = _list.where((ap) => ap.title != apyar.title).toList();
    _list.clear();
    _list.addAll(res);

    notifyListeners();
  }

  //
  // တစ်ခါတည်း အပြီး replace လုပ်မယ်
  //
  Future<void> replaceTitle(String title, ApyarModel apyar) async {
    final res = _list.map((ap) {
      if (ap.title == title) {
        return apyar;
      }
      return ap;
    }).toList();
    _list.clear();
    _list.addAll(res);
    _apyar = apyar;

    notifyListeners();
  }

  bool isExistsTitle(String title) {
    final res = _list.where((ap) => ap.title == title);
    if (res.isNotEmpty) return true;
    return false;
  }
}
