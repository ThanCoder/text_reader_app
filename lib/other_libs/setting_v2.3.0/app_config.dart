import 'dart:convert';
import 'dart:io';

import 'package:t_widgets/theme/t_theme_services.dart';
import 'package:text_reader/app/core/types/database_types.dart';

import 'package:than_pkg/than_pkg.dart';

import 'setting.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppConfig {
  String customPath;
  String forwardProxyUrl;
  String browserForwardProxyUrl;
  String proxyUrl;
  String hostUrl;
  bool isUseCustomPath;
  bool isUseForwardProxy;
  bool isUseProxy;
  bool isDarkTheme;
  DatabaseTypes databaseType;
  TThemeModes themeMode;
  AppConfig({
    required this.customPath,
    required this.forwardProxyUrl,
    required this.browserForwardProxyUrl,
    required this.proxyUrl,
    required this.hostUrl,
    required this.isUseCustomPath,
    required this.isUseForwardProxy,
    required this.isUseProxy,
    required this.isDarkTheme,
    required this.databaseType,
    required this.themeMode,
  });

  factory AppConfig.create({
    String customPath = '',
    String forwardProxyUrl = '',
    String browserForwardProxyUrl = '',
    String proxyUrl = '',
    String hostUrl = '',
    bool isUseCustomPath = false,
    bool isUseForwardProxy = false,
    bool isUseProxy = false,
    bool isDarkTheme = false,
    DatabaseTypes databaseType = DatabaseTypes.folder,
    TThemeModes themeMode = TThemeModes.light,
  }) {
    return AppConfig(
      customPath: customPath,
      forwardProxyUrl: forwardProxyUrl,
      browserForwardProxyUrl: browserForwardProxyUrl,
      proxyUrl: proxyUrl,
      hostUrl: hostUrl,
      isUseCustomPath: isUseCustomPath,
      isUseForwardProxy: isUseForwardProxy,
      isUseProxy: isUseProxy,
      isDarkTheme: isDarkTheme,
      databaseType: databaseType,
      themeMode: themeMode,
    );
  }

  // map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customPath': customPath,
      'forwardProxyUrl': forwardProxyUrl,
      'browserForwardProxyUrl': browserForwardProxyUrl,
      'proxyUrl': proxyUrl,
      'hostUrl': hostUrl,
      'isUseCustomPath': isUseCustomPath,
      'isUseForwardProxy': isUseForwardProxy,
      'isUseProxy': isUseProxy,
      'isDarkTheme': isDarkTheme,
      'databaseType': databaseType.name,
      'themeMode': themeMode.name,
    };
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    final databaseTypeStr = map.getString(['databaseType']);
    final themeModeStr = map.getString(['themeMode']);
    return AppConfig(
      customPath: map['customPath'] as String,
      forwardProxyUrl: map['forwardProxyUrl'] as String,
      browserForwardProxyUrl: map['browserForwardProxyUrl'] as String,
      proxyUrl: map['proxyUrl'] as String,
      hostUrl: map['hostUrl'] as String,
      isUseCustomPath: map['isUseCustomPath'] as bool,
      isUseForwardProxy: map['isUseForwardProxy'] as bool,
      isUseProxy: map['isUseProxy'] as bool,
      isDarkTheme: map['isDarkTheme'] as bool,
      databaseType: DatabaseTypes.getType(databaseTypeStr),
      themeMode: TThemeModes.getName(themeModeStr),
    );
  }

  AppConfig copyWith({
    String? customPath,
    String? forwardProxyUrl,
    String? browserForwardProxyUrl,
    String? proxyUrl,
    String? hostUrl,
    bool? isUseCustomPath,
    bool? isUseForwardProxy,
    bool? isUseProxy,
    bool? isDarkTheme,
    DatabaseTypes? databaseType,
    TThemeModes? themeMode,
  }) {
    return AppConfig(
      customPath: customPath ?? this.customPath,
      forwardProxyUrl: forwardProxyUrl ?? this.forwardProxyUrl,
      browserForwardProxyUrl:
          browserForwardProxyUrl ?? this.browserForwardProxyUrl,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      hostUrl: hostUrl ?? this.hostUrl,
      isUseCustomPath: isUseCustomPath ?? this.isUseCustomPath,
      isUseForwardProxy: isUseForwardProxy ?? this.isUseForwardProxy,
      isUseProxy: isUseProxy ?? this.isUseProxy,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      databaseType: databaseType ?? this.databaseType,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  // void
  Future<void> save() async {
    try {
      final file = File('${Setting.appConfigPath}/$configName');
      final contents = JsonEncoder.withIndent(' ').convert(toMap());
      await file.writeAsString(contents);
      // appConfigNotifier.value = this;
      Setting.instance.initSetConfigFile();
    } catch (e) {
      Setting.showDebugLog(e.toString(), tag: 'AppConfig:save');
    }
  }

  // get config
  static Future<AppConfig> getConfig() async {
    final file = File('${Setting.appConfigPath}/$configName');
    if (file.existsSync()) {
      final source = await file.readAsString();
      return AppConfig.fromMap(jsonDecode(source));
    }
    return AppConfig.create();
  }

  static String configName = 'main.config.json';
}
