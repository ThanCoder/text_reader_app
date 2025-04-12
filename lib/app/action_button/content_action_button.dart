import 'package:apyar/app/dialogs/index.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/screens/apyar_edit_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentActionButton extends StatefulWidget {
  void Function() onBackpress;
  ContentActionButton({
    super.key,
    required this.onBackpress,
  });

  @override
  State<ContentActionButton> createState() => _ContentActionButtonState();
}

class _ContentActionButtonState extends State<ContentActionButton> {
  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApyarEditFormScreen(),
                    ),
                  );
                },
              ),
              // delete
              ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.delete_forever),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteConfirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteConfirm() {
    final apyar = context.read<ApyarProvider>().getCurrent;
    if (apyar == null) return;
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        contentText: '`${apyar.title}` ဖျက်ချင်တာ သေချာပြီလား?',
        onCancel: () {},
        onSubmit: () async {
          context.read<ApyarProvider>().remove(apyar);
          await apyar.delete();

          widget.onBackpress();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _showMenu,
      icon: Icon(Icons.more_vert),
    );
  }
}
