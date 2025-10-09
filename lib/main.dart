import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/services/post_services.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/path_util.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';
import 'package:than_pkg/than_pkg.dart';
import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThanPkg.instance.init();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.png',
    getDarkMode: () => Setting.getAppConfig.isDarkTheme,
    onDownloadImage: (url, savePath) async {
      await Dio().download(url, savePath);
    },
  );

  await Setting.instance.initSetting(
    appName: 'text_reader_app',
    onShowMessage: (context, message) {
      showTSnackBar(context, message);
      PostServices.clearDBCache();
    },
  );
  // recent
  await TRecentDB.getInstance.init(
    rootPath: PathUtil.getDatabasePath(name: 'recent.db.json'),
  );

  runApp(MyApp());
}
