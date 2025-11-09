import 'dart:io';

import 'package:flutter/material.dart';
import 'package:text_reader/app/ui/bookmark/bookmark_button.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/ui/screens/text_reader/reader_config.dart';
import 'package:text_reader/app/ui/screens/text_reader/reader_config_dialog.dart';
import 'package:text_reader/app/services/post_services.dart';
import 'package:than_pkg/than_pkg.dart';

typedef OnConfigUpdatedCallback = void Function(ReaderConfig updatedConfig);

class TextReaderScreen extends StatefulWidget {
  final Post post;
  final ReaderConfig config;
  final OnConfigUpdatedCallback? onConfigUpdated;
  const TextReaderScreen({
    super.key,
    required this.post,
    required this.config,
    this.onConfigUpdated,
  });

  @override
  State<TextReaderScreen> createState() => _TextReaderScreenState();
}

class _TextReaderScreenState extends State<TextReaderScreen> {
  late ReaderConfig config;
  @override
  void initState() {
    config = widget.config;
    super.initState();
    init();
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleKeepScreen(isKeep: false);
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    super.dispose();
  }

  List<String> list = [];
  bool isFullScreen = false;

  Future<void> init() async {
    try {
      final path = await PostServices.getDB.storage.getPath(
        '${widget.post.id}/1',
      );
      final file = File(path ?? '');
      if (!file.existsSync()) return;
      final content = await file.readAsString();
      list = content.split('\n\n');
      setState(() {});
      initConfig();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void initConfig() {
    ThanPkg.platform.toggleKeepScreen(isKeep: config.isKeepScreening);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onConfigUpdated?.call(config);
        });
      },
      child: Scaffold(
        body: GestureDetector(
          onLongPress: _showConfigDialog,
          onSecondaryTap: _showConfigDialog,
          onDoubleTap: () {
            ThanPkg.platform.toggleFullScreen(isFullScreen: !isFullScreen);
            setState(() {
              isFullScreen = !isFullScreen;
            });
          },
          child: CustomScrollView(
            slivers: [
              isFullScreen
                  ? SliverToBoxAdapter()
                  : SliverAppBar(
                      title: Text(widget.post.title),
                      snap: true,
                      floating: true,
                      actions: [BookmarkButton(post: widget.post)],
                    ),
              SliverList.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: config.paddingY,
                    horizontal: config.paddingX,
                  ),
                  child: Text(
                    list[index],
                    style: TextStyle(fontSize: config.fontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfigDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReaderConfigDialog(
        config: config,
        onUpdated: (updatedConfig) {
          config = updatedConfig;
          initConfig();
        },
      ),
    );
  }
}
