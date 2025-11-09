// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:t_widgets/theme/t_theme_services.dart';
import 'package:text_reader/app/my_app.dart';
import 'package:than_pkg/than_pkg.dart';

import 'package:text_reader/app/services/post_services.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/path_util.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThanPkg.instance.init();

  TThemeServices.instance.init();
  //theme check event
  TThemeServices.instance.checkThemeEvent();

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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final span = TextSpanParser(text: File('CHANGELOG.md').readAsStringSync());

  @override
  void initState() {
    super.initState();

    // span.addRules(
    //   rules: TextSpanParserRules(
    //     regExp: RegExp(r'^(http|https):\/\/.+'),
    //     builder: (match) {
    //       print('match: $match');
    //       return TextSpan(text: 'url');
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    span.clearRules();
    span.addRules(
      rules: TextSpanParserRules(
        regExp: RegExp(r'##\s?.+'),
        builder: (match) {
          return TextSpan(
            text: match.replaceAll('##', ''),
            style: TextStyle(fontSize: 18),
          );
        },
      ),
    );
    span.addRules(
      rules: TextSpanParserRules(
        regExp: RegExp(r'#\s?.+'),
        builder: (match) {
          return TextSpan(
            text: match.replaceAll('#', ''),
            style: TextStyle(fontSize: 23),
          );
        },
      ),
    );
    return MaterialApp(
      home: Scaffold(body: Text.rich(TextSpan(children: span.getResult()))),
    );
  }
}

class TextSpanParserRules {
  final RegExp regExp;
  final TextSpan Function(String match) builder;
  TextSpanParserRules({required this.regExp, required this.builder});
}

class TextSpanParser {
  final String text;
  final List<TextSpanParserRules> _rules = [];
  TextSpanParser({required this.text});

  void clearRules() {
    _rules.clear();
  }

  void addRules({required TextSpanParserRules rules}) {
    _rules.add(rules);
  }

  List<TextSpan> getResult() {
    if (_rules.isEmpty) {
      return [TextSpan(text: text)];
    }
    final List<TextSpan> spans = [];
    int start = 0;

    final regCombinedPatterns = _rules.map((e) => e.regExp.pattern).join('|');
    final combinedReg = RegExp(regCombinedPatterns);

    for (var match in combinedReg.allMatches(text)) {
      // print('start: ${match.start}- end: ${match.end}');
      // print(match.group(0));

      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      // callback
      final matchText = match.group(0);
      for (var rule in _rules) {
        rule.regExp.hasMatch(matchText!);
        spans.add(rule.builder(matchText));
        break;
      }

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}
