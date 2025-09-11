import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/services/post_services.dart';

class EditPostScreen extends StatefulWidget {
  Post post;
  bool isUpdate;
  void Function(Post updatedPost) onUpdated;
  EditPostScreen({
    super.key,
    required this.post,
    required this.onUpdated,
    this.isUpdate = false,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocusNode = FocusNode();
  final bodyFocusNode = FocusNode();
  String? titleError;
  List<Post> existsList = [];
  int currentIndex = 1;
  bool isLoading = false;

  @override
  void initState() {
    titleController.text = widget.post.title;
    if (widget.post.body.isNotEmpty) {
      bodyController.text = widget.post.body;
    } else {
      // bodyController.text = post.getBody;
    }
    super.initState();
    init();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    bodyController.dispose();
    bodyFocusNode.dispose();
    super.dispose();
  }

  void init() async {
    bodyController.text = await _getContentText();
  }

  @override
  Widget build(BuildContext context) {
    return TScaffold(
      appBar: AppBar(title: Text('Edit: ${widget.post.title}')),
      body: isLoading
          ? Center(child: TLoader.random())
          : TScrollableColumn(
              children: [
                // cover
                TCoverChooser(
                  coverPath: widget.post.getCoverPath,
                  onChanged: () {
                    titleFocusNode.unfocus();
                    bodyFocusNode.unfocus();
                  },
                ),
                TTextField(
                  label: Text('Title'),
                  controller: titleController,
                  maxLines: 1,
                  isSelectedAll: true,
                  errorText: titleError,
                  onChanged: _onTitleChanged,
                  onSubmitted: (_) => _onUpdate(),
                ),
                // tags
                // TTagsWrapView(
                //   title: Text('Tags'),
                //   values: post.getTags,
                //   allTags: post.getAllTags,
                //   onApply: (values) {
                //     post.setTags(values);
                //     setState(() {});
                //   },
                // ),
                TTextField(
                  label: Text('Body'),
                  controller: bodyController,
                  maxLines: null,
                ),
              ],
            ),
      floatingActionButton: isLoading
          ? null
          : titleError != null
          ? null
          : FloatingActionButton(
              onPressed: _onUpdate,
              child: Icon(Icons.save_as_rounded),
            ),
    );
  }

  Future<String> _getContentText() async {
    final file = File('$_getPostPath/$currentIndex');
    if (!file.existsSync()) return '';
    return await file.readAsString();
  }

  String get _getPostPath {
    final dir = Directory(
      '${PostServices.getDB.storage.root}/${widget.post.id}',
    );
    if (!dir.existsSync()) {
      dir.create();
    }
    return dir.path;
  }

  void _onTitleChanged(String text) {
    if (text.isEmpty) return;
    final index = existsList.indexWhere((e) => e.title == text);
    if (index != -1) {
      //ရှိနေတယ်
      titleError = 'post ရှိနေပါတယ်!...';
    } else {
      // မရှိ
      titleError = null;
    }
    setState(() {});
  }

  void _onUpdate() async {
    try {
      setState(() {
        isLoading = true;
      });
      final file = File('$_getPostPath/$currentIndex');
      await file.writeAsString(bodyController.text);
      // change id

      if (!mounted) return;
      // close
      Navigator.pop(context);

      widget.onUpdated(
        widget.post.copyWith(
          id: titleController.text,
          title: titleController.text,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
