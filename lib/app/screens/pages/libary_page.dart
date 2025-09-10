import 'package:flutter/material.dart';
import 'package:text_reader/app/bookmark/bookmark_sliver_list.dart';

class LibaryPage extends StatefulWidget {
  const LibaryPage({super.key});

  @override
  State<LibaryPage> createState() => _LibaryPageState();
}

class _LibaryPageState extends State<LibaryPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('Libary')),
          BookmarkSliverList(),
        ],
      ),
    );
  }

  
}
