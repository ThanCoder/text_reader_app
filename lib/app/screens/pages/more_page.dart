import 'package:flutter/material.dart';
import 'package:text_reader/other_libs/setting_v2.0.0/setting.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Page'),
      ),
      body: Column(
        children: [
          // theme
          Setting.getThemeSwitcher,
          Divider(),
          Setting.getSettingListTile,
          // setting
        ],
      ),
    );
  }
}
