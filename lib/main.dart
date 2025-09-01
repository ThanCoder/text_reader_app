import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/services/post_services.dart';
import 'package:text_reader/other_libs/fetcher_v1.0.0/fetcher.dart';
import 'package:text_reader/other_libs/setting_v2.2.0/setting.dart';
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
  await Fetcher.instance.init(
    onGetHttpContent: (url) async {
      final res = await Dio().get(url);
      return res.data.toString();
    },
  );

  await Setting.instance.initSetting(
    appName: 'text_reader_app',
    onShowMessage: (context, message) {
      showTSnackBar(context, message);
      PostServices.clearDBCache();
    },
  );
  // fetcher

  runApp(MyApp());
}
