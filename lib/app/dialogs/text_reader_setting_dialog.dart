import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';

class TextReaderSettingDialog extends StatefulWidget {
  AppConfigModel config;
  void Function(AppConfigModel appConfig) onApply;
  TextReaderSettingDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<TextReaderSettingDialog> createState() =>
      _TextReaderSettingDialogState();
}

class _TextReaderSettingDialogState extends State<TextReaderSettingDialog> {
  late AppConfigModel config;
  @override
  void initState() {
    config = widget.config;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Setting'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            //keep screen
            ListTileWithDesc(
              title: 'Keep Screen',
              trailing: Checkbox(
                value: config.isKeepScreen,
                onChanged: (value) {
                  setState(() {
                    config.isKeepScreen = value!;
                  });
                },
              ),
            ),
            //keep screen
            ListTileWithDesc(
              title: 'Font Size',
              trailing: FontListWiget(
                fontSize: config.fontSize.toInt(),
                onChange: (fontSize) {
                  setState(() {
                    config.fontSize = fontSize.toDouble();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onApply(config);
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}
