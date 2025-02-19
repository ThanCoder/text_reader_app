import 'package:apyar/app/notifiers/app_notifier.dart';
import 'package:apyar/app/screens/index.dart';
import 'package:apyar/app/services/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      final res = await PackageInfo.fromPlatform();
      setState(() {
        version = res.version;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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
              leading: const Icon(Icons.dark_mode_outlined),
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
            //version
            ListTileWithDesc(
              leading: Icon(Icons.cloud_upload),
              title: 'Version',
              desc: 'Current Version is $version',
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
