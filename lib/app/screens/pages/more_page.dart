import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets_dev.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/thancoder_about_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More Page')),
      body: TScrollableColumn(
        children: [
          // theme
          Setting.getThemeModeChooserWidget,
          Divider(),
          Setting.getSettingListTileWidget,
          // setting
          Divider(),
          ThancoderAboutWidget(),
        ],
      ),
    );
  }
}
