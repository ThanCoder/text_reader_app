import 'package:apyar/app/notifiers/app_notifier.dart';
import 'package:apyar/app/screens/index.dart';
import 'package:apyar/app/services/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            //theme
            ListTileWithDesc(
              title: 'Dark Theme',
              leading: const Icon(Icons.settings),
              trailing: ValueListenableBuilder(
                valueListenable: isDarkThemeNotifier,
                builder: (context, value, child) => Checkbox(
                  value: value,
                  onChanged: (value) {
                    isDarkThemeNotifier.value = value!;
                    //save config
                    final appConfig = appConfigNotifier.value;
                    appConfig.isDarkTheme = value;
                    CherryToast.success(
                      title: Text('Saved Setting'),
                      inheritThemeColors: true,
                    ).show(context);
                    setConfigFile(appConfig);
                  },
                ),
              ),
            ),
            //setting
            ListTileWithDesc(
              leading: Icon(Icons.settings),
              title: 'Setting',
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppSettingScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
