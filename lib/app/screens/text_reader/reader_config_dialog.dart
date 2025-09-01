import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'reader_config.dart';

typedef OnUpdateConfigCallback = void Function(ReaderConfig updatedConfig);

class ReaderConfigDialog extends StatefulWidget {
  final ReaderConfig config;
  final OnUpdateConfigCallback? onUpdated;
  const ReaderConfigDialog({super.key, required this.config, this.onUpdated});

  @override
  State<ReaderConfigDialog> createState() => _ReaderConfigDialogState();
}

class _ReaderConfigDialogState extends State<ReaderConfigDialog> {
  late ReaderConfig config;
  final paddingXController = TextEditingController();
  final paddingYController = TextEditingController();
  final fontSizeController = TextEditingController();

  @override
  void initState() {
    config = widget.config;
    super.initState();
    init();
  }

  void init() {
    paddingXController.text = config.paddingX.toInt().toString();
    paddingYController.text = config.paddingY.toInt().toString();
    fontSizeController.text = config.fontSize.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      contentPadding: EdgeInsets.all(6),
      scrollable: true,
      content: TScrollableColumn(
        children: [
          SwitchListTile.adaptive(
            value: config.isKeepScreening,
            title: Text('Screen မပိတ်ဘူး'),
            onChanged: (value) {
              setState(() {
                config.isKeepScreening = value;
              });
            },
          ),
          // font
          TNumberField(
            label: Text('Font Size'),
            maxLines: 1,
            controller: fontSizeController,
            onChanged: (text) {
              if (double.tryParse(text) == null) return;
              config.fontSize = double.parse(text);
            },
          ),
          // padding
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reader Text Padding',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TNumberField(
                label: Text('Left-Right'),
                maxLines: 1,
                controller: paddingXController,
                onChanged: (text) {
                  if (double.tryParse(text) == null) return;
                  config.paddingX = double.parse(text);
                },
              ),
              TNumberField(
                label: Text('Top-Bottom'),
                maxLines: 1,
                controller: paddingYController,
                onChanged: (text) {
                  if (double.tryParse(text) == null) return;
                  config.paddingY = double.parse(text);
                },
              ),
            ],
          ),
        ],
      ),
      actions: _getActions(),
    );
  }

  List<Widget> _getActions() {
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Close'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          widget.onUpdated?.call(config);
        },
        child: Text('Update'),
      ),
    ];
  }
}
