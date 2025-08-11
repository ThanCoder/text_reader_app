import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/models/post_model.dart';
import 'package:text_reader/other_libs/fetcher_v1.0.0/fetcher.dart';
import 'package:text_reader/other_libs/setting_v2.0.0/setting.dart';
import 'package:than_pkg/than_pkg.dart';
import 'app/my_app.dart';

void main() async {
  await AppRestartWidget.initializeApp(
    onInitializeApp: () async {
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
        isAppRefreshConfigPathChanged: true,
      );
      // fetcher

      await Hive.initFlutter(PathUtil.getDatabasePath());
      // adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PostModelAdapter());
      }

      await Hive.openBox<PostModel>(PostModel.dbName);
    },
  );

  runApp(
    AppRestartWidget(
      child: MyApp(),
      onRestartLogic: () async {
        await Hive.close();
      },
    ),
  );

  // runApp(
  //     // MultiProvider(
  //     //   providers: [
  //     //     // ChangeNotifierProvider(create: (context) => ApyarProvider()),
  //     //     // ChangeNotifierProvider(create: (context) => BookmarkProvider()),
  //     //   ],
  //     //   child: const MyApp(),
  //     // ),
  //     const MyApp());
}
