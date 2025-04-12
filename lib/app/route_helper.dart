import 'package:apyar/app/constants.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:apyar/app/screens/apyar_edit_form_screen.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_reader/text_reader_config_model.dart';
import 'text_reader/text_reader_screen.dart';

void goApyarEditFormScreen(BuildContext context, ApyarModel apyar) async {
  await context.read<ApyarProvider>().setCurrent(apyar);
  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ApyarEditFormScreen(),
    ),
  );
}

void goTextReaderScreen(BuildContext context, ApyarModel apyar) async {
  final configPath =
      '${PathUtil.instance.getConfigPath()}/$appTextReaderConfigFileName';

  await context.read<ApyarProvider>().setCurrent(apyar);
  if (!context.mounted) return;
  final isExists = await context.read<BookmarkProvider>().isExists(apyar);
  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TextReaderScreen(
        data: apyar,
        config: TextReaderConfigModel.fromPath(configPath),
        bookmarkValue: isExists,
        onBookmarkChanged: (bookmarkValue) {
          context.read<BookmarkProvider>().toggle(apyar);
        },
        onConfigChanged: (config) {
          config.savePath(configPath);
        },
      ),
    ),
  );
}
