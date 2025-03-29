// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:apyar/app/constants.dart';
import 'package:apyar/app/dialogs/text_reader_setting_dialog.dart';
import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/notifiers/app_notifier.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:apyar/app/screens/apyar_form_screen.dart';
import 'package:apyar/app/services/index.dart';
import 'package:flutter/material.dart';

import 'package:apyar/app/notifiers/apyar_notifier.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:than_pkg/than_pkg.dart';

class TextReaderScreen extends StatefulWidget {
  const TextReaderScreen({super.key});

  @override
  State<TextReaderScreen> createState() => _TextReaderScreenState();
}

class _TextReaderScreenState extends State<TextReaderScreen> {
  int currentIndex = 1;
  List<_ListModel> list = [];
  final ScrollController _scrollController = ScrollController();
  double lastScroll = 0;
  bool isFullScreen = false;
  late AppConfigModel appConfig;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    appConfig = appConfigNotifier.value;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void _close() async {
    if (Platform.isAndroid) {
      await ThanPkg.android.app.toggleKeepScreenOn(isKeep: false);
      await ThanPkg.android.app.hideFullScreen();
    }
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  void init() {
    try {
      final apyar = currentApyarNotifier.value;
      if (apyar == null) return;
      context.read<BookmarkProvider>().checkExists(apyarTitle: apyar.title);
      setState(() {
        list.add(_ListModel(path: '${apyar.path}/$currentIndex'));
      });
      _initConfig();
    } catch (e) {
      debugPrint('init: ${e.toString()}');
    }
  }

  void _initConfig() {
    ThanPkg.platform
        .toggleKeepScreen(isKeep: appConfigNotifier.value.isKeepScreen);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        lastScroll != _scrollController.position.maxScrollExtent) {
      lastScroll = _scrollController.position.maxScrollExtent;
      currentIndex++;
      final file = File('${currentApyarNotifier.value!.path}/$currentIndex');
      if (file.existsSync()) {
        //ရှိနေရင်
        setState(() {
          list.add(_ListModel(
              path: '${currentApyarNotifier.value!.path}/$currentIndex'));
        });
      }
    }
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
    ThanPkg.platform.toggleFullScreen(isFullScreen: isFullScreen);
  }

  void _showSettingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return TextReaderSettingDialog(
            config: appConfig,
            onApply: (_appConfig) {
              try {
                setState(() {
                  appConfig = _appConfig;
                });
                appConfigNotifier.value = _appConfig;
                setConfigFile(_appConfig);
                _initConfig();
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          );
        });
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 200,
          ),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApyarFormScreen(),
                    ),
                  );
                },
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _showSettingDialog();
                },
                leading: Icon(Icons.settings),
                title: Text('Setting'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentApyarNotifier,
      builder: (context, apyar, child) {
        if (apyar == null) {
          return Center(child: Text('apyar is null'));
        }
        return MyScaffold(
          appBar: isFullScreen
              ? null
              : AppBar(
                  title: Text(apyar.title),
                  actions: [
                    //bm
                    IconButton(
                      onPressed: () {
                        context
                            .read<BookmarkProvider>()
                            .toggle(apyarTitle: apyar.title);
                      },
                      icon: context.watch<BookmarkProvider>().isExists
                          ? Icon(
                              Icons.bookmark_remove,
                              color: dangerColor,
                            )
                          : Icon(
                              Icons.bookmark_add,
                              color: activeColor,
                            ),
                    ),
                    //aciton
                    IconButton(
                      onPressed: _showMenu,
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
          body: GestureDetector(
            onDoubleTap: _toggleFullScreen,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final listItem = list[index];
                return Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: MyImageFile(
                        path: apyar.coverPath,
                        borderRadius: 5,
                      ),
                    ),
                    Text(
                      listItem.content,
                      style: TextStyle(
                        fontSize: appConfig.fontSize,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

//list model
class _ListModel {
  String path;
  String content = '';
  late String coverPath;
  _ListModel({required this.path}) {
    coverPath = '$path.png';
    content = _getContent(path);
  }

  String _getContent(String path) {
    String res = '';
    try {
      final file = File(path);
      if (file.existsSync()) {
        res = file.readAsStringSync();
      }
    } catch (e) {
      debugPrint('_getContent: ${e.toString()}');
    }
    return res;
  }
}
