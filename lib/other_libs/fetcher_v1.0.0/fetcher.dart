import 'package:flutter/material.dart';

export 'others/index.dart';

class Fetcher {
  static final Fetcher instance = Fetcher._();
  Fetcher._();
  factory Fetcher() => instance;

  static bool isShowDebugLog = true;
  void Function(BuildContext context, String message)? _onShowMessage;
  Future<String> Function(String url)? onGetHttpContent;

  Future<void> init({
    bool isShowDebugLog = true,
    void Function(BuildContext context, String message)? onShowMessage,
    Future<String> Function(String url)? onGetHttpContent,
  }) async {
    Fetcher.isShowDebugLog = isShowDebugLog;
    _onShowMessage = onShowMessage;
    this.onGetHttpContent = onGetHttpContent;
  }

  void showMessage(BuildContext context, String message) {
    if (_onShowMessage == null) return;
    _onShowMessage!(context, message);
  }

  static void showDebugLog(String message, {String? tag}) {
    if (!isShowDebugLog) return;
    if (tag != null) {
      debugPrint('[$tag]: $message');
    } else {
      debugPrint(message);
    }
  }

  static String get getErrorLog {
    return ''' await Setting.instance.initSetting''';
  }
}
