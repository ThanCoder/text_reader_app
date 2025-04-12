import 'package:apyar/app/components/index.dart';
import 'package:apyar/app/dialogs/core/confirm_dialog.dart';
import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApyarEditFormScreen extends StatefulWidget {
  const ApyarEditFormScreen({super.key});

  @override
  State<ApyarEditFormScreen> createState() => _ApyarEditFormScreenState();
}

class _ApyarEditFormScreenState extends State<ApyarEditFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    init();
  }

  late ApyarModel apyar;
  int number = 1;
  bool showSaveButton = false;

  void init() {
    final res = context.read<ApyarProvider>().getCurrent;
    if (res == null) {
      showDialogMessage(context, 'apyar null ဖြစ်နေပါတယ်!');
      return;
    }
    apyar = res;
    titleController.text = apyar.title;
    contentController.text = apyar.getContent();
    // print(apyar.getContent());
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _incChapter() {
    number++;
    contentController.text = apyar.getNumberContent(number);
    setState(() {
      showSaveButton = true;
    });
  }

  void _descChapter() {
    if (number <= 1) return;
    number--;
    contentController.text = apyar.getNumberContent(number);
    setState(() {
      showSaveButton = true;
    });
  }

  void _saveData() async {
    try {
      if (apyar.title != titleController.text) {
        //update folder
        final newPath = await apyar.updateTitle(titleController.text);
        if (!mounted) return;
        final newApyar = ApyarModel.fromPath(newPath);
        context.read<ApyarProvider>().replaceTitle(apyar.title, newApyar);
        newApyar.saveNumberContent(number, contentController.text);
        if (!mounted) return;
        setState(() {
          showSaveButton = false;
        });
        showMessage(context, 'Saved');
      } else {
        //change chapter
        apyar.saveNumberContent(number, contentController.text);
        setState(() {
          showSaveButton = false;
        });
        showMessage(context, 'Saved');
      }
    } catch (e) {
      showDialogMessage(context, e.toString());
    }
  }

  void _deleteChapter() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: '`$number` ကိုဖျက်ချင်တာ သေချာပြီလား?',
        onCancel: () {},
        onSubmit: () {
          try {
            apyar.deleteNumber(number);
            contentController.text = '';
            setState(() {
              showSaveButton = false;
            });
          } catch (e) {
            showDialogMessage(context, e.toString());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apyar = context.watch<ApyarProvider>().getCurrent!;
    return MyScaffold(
      appBar: AppBar(
        title: Text('Edit: ${apyar.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverComponents(coverPath: apyar.coverPath),
            TTextField(
              label: Text('Title'),
              controller: titleController,
              onChanged: (value) {
                if (!showSaveButton) {
                  setState(() {
                    showSaveButton = true;
                  });
                }
              },
            ),
            //index
            Row(
              children: [
                Text('Current Index: $number'),
                IconButton(
                  onPressed: _incChapter,
                  icon: Icon(Icons.add_circle),
                ),
                IconButton(
                  onPressed: number == 1 ? null : _descChapter,
                  icon: Icon(Icons.remove_circle),
                ),
                number != 1
                    ? IconButton(
                        color: Colors.red,
                        onPressed: _deleteChapter,
                        icon: Icon(Icons.delete_forever),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            TTextField(
              label: Text('Content'),
              controller: contentController,
              maxLines: 10,
              onChanged: (value) {
                if (!showSaveButton) {
                  setState(() {
                    showSaveButton = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: showSaveButton
          ? FloatingActionButton(
              onPressed: _saveData,
              child: Icon(Icons.save_as_rounded),
            )
          : null,
    );
  }
}
