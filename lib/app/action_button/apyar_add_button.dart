import 'package:apyar/app/dialogs/core/rename_dialog.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApyarAddButton extends StatefulWidget {
  const ApyarAddButton({super.key});

  @override
  State<ApyarAddButton> createState() => _ApyarAddButtonState();
}

class _ApyarAddButtonState extends State<ApyarAddButton> {
  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.add_rounded),
                title: Text('New'),
                onTap: () {
                  Navigator.pop(context);
                  _addApyar();
                },
              ),
              ListTile(
                leading: Icon(Icons.sort_by_alpha),
                title: Text('Sort'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addApyar() async {
    final provider = context.read<ApyarProvider>();
    // await provider.initList(isReset: true, showLoading: false);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        title: 'New Apyar',
        onCheckIsError: (title) {
          final isExist = provider.isExistsTitle(title);
          if (isExist) return 'ရှိနေပြီးသား ဖြစ်နေပါတယ်!!!';
          return null;
        },
        onCancel: () {},
        onSubmit: (title) {
          try {
            final apyar = ApyarModel.create(title);
            context.read<ApyarProvider>().insert(apyar);
            goApyarEditFormScreen(context, apyar);
          } catch (e) {
            debugPrint(e.toString());
          }
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
