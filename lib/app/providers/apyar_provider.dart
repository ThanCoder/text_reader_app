import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/services/index.dart';
import 'package:flutter/material.dart';

class ApyarProvider with ChangeNotifier {
  final List<ApyarModel> _list = [];
  bool _isLoading = false;

  List<ApyarModel> get getList => _list;
  bool get isLoading => _isLoading;

  Future<void> initList() async {
    try {
      _isLoading = true;
      notifyListeners();

      // await Future.delayed(const Duration(seconds: 3));

      final res = await getApyarListIsolate();

      _list.clear();
      _list.addAll(res);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('initList: ${e.toString()}');
    }
  }
}
