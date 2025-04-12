import 'package:apyar/app/constants.dart';
import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/notifiers/app_notifier.dart';
import 'package:apyar/app/services/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  late AppConfigModel config;
  final TextEditingController customPathController = TextEditingController();

  @override
  void initState() {
    config = appConfigNotifier.value;
    super.initState();
    init();
  }

  void init() {
    if (config.customPath.isEmpty) {
      customPathController.text = '${getAppExternalRootPath()}/.$appName';
    } else {
      customPathController.text = config.customPath;
    }
  }

  void _save() async {
    //check permission
    if (config.isUseCustomPath) {
      final isGranted = await ThanPkg.platform.isStoragePermissionGranted();
      if (!isGranted) {
        await ThanPkg.platform.requestStoragePermission();
        return;
      }
    }
    config.customPath = customPathController.text;
    setConfigFile(config);
    await initAppConfigService();

    if (!mounted) return;

    CherryToast.success(
      title: Text('Setting Saved'),
      inheritThemeColors: true,
    ).show(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTileWithDesc(
              title: 'Custom Path',
              desc: 'ကြိုက်နှစ်သက်ရာ path',
              trailing: Checkbox(
                value: config.isUseCustomPath,
                onChanged: (value) {
                  setState(() {
                    config.isUseCustomPath = value!;
                  });
                },
              ),
            ),
            //custom path
            config.isUseCustomPath
                ? Card(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TTextField(
                      hintText: 'Custom Path',
                      label: Text('Custom Path'),
                      controller: customPathController,
                    ),
                  ))
                : Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: Icon(Icons.save_rounded),
      ),
    );
  }
}
