import 'package:flutter/material.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/ui/screens/text_reader/reader_config.dart';
import 'package:text_reader/app/ui/screens/text_reader/text_reader_screen.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/path_util.dart';

void goRoute(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
}) {
  Navigator.push(context, MaterialPageRoute(builder: builder));
}

void goTextReader(BuildContext context, {required Post post}) {
  final path = PathUtil.getConfigPath(name: 'reader.config.json');
  goRoute(
    context,
    builder: (context) => TextReaderScreen(
      post: post,
      config: ReaderConfig.fromPath(path),
      onConfigUpdated: (updatedConfig) {
        updatedConfig.savePath(path);
      },
    ),
  );
}

// void goEditPostScreen(BuildContext context,Post post,){
//   Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
// }
