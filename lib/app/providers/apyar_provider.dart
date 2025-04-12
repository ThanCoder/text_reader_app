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

  Future<void> initList({bool isReset = false}) async {
    try {
      if (isReset == false && _list.isNotEmpty) {
        return;
      }
      _isLoading = true;
      notifyListeners();

      final res = await ApyarServices.instance.getList();

      _list.clear();
      _list.addAll(res);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> setCurrent(ApyarModel apyar) async {
    _apyar = apyar;
    notifyListeners();
  }
}
