import 'dart:io';

import 'package:apyar/app/notifiers/apyar_notifier.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';

class ApyarFormScreen extends StatefulWidget {
  const ApyarFormScreen({super.key});

  @override
  State<ApyarFormScreen> createState() => _ApyarFormScreenState();
}

class _ApyarFormScreenState extends State<ApyarFormScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController chapterBodyController = TextEditingController();
  int currentChapter = 1;

  void init() {
    final apyar = currentApyarNotifier.value;
    if (apyar == null) return;
    titleController.text = apyar.title;
    chapterBodyController.text = _getChapterBody(apyar.path);
  }

  String _getChapterBody(String apyarPath) {
    final file = File('${currentApyarNotifier.value!.path}/$currentChapter');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }

  @override
  Widget build(BuildContext context) {
    final apyar = currentApyarNotifier.value;
    if (apyar == null) return Text('apyar is null');
    return MyScaffold(
      appBar: AppBar(
        title: Text('Apyar Form `${apyar.title}`'),
      ),
      body: Column(
        spacing: 10,
        children: [
          TTextField(
            label: Text('Title...'),
            controller: titleController,
          ),
          const Divider(),
          //chapter

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 5,
                  children: [
                    Text('Chapter'),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 100,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) => Text('${index + 1}'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    spacing: 5,
                    children: [
                      Text('Chapter Content'),
                      Expanded(
                        child: TTextField(
                          label: Text('Body...'),
                          controller: chapterBodyController,
                          maxLines: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
