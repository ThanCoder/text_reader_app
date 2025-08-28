import 'dart:io';

import 'package:flutter/material.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/services/post_services.dart';

class TextReaderScreen extends StatefulWidget {
  Post post;
  TextReaderScreen({super.key, required this.post});

  @override
  State<TextReaderScreen> createState() => _TextReaderScreenState();
}

class _TextReaderScreenState extends State<TextReaderScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<String> list = [];

  Future<void> init() async {
    try {
      final path = await PostServices.getAbsPath('${widget.post.title}/1');
      final file = File(path);
      if (!file.existsSync()) return;
      final content = await file.readAsString();
      list = content.split('\n\n');
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(widget.post.title),
            snap: true,
            floating: true,
          ),
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(list[index], style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
