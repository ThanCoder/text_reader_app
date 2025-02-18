import 'package:apyar/app/components/bookmark_list_view.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/notifiers/apyar_notifier.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:apyar/app/screens/text_reader_screen.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    await context.read<BookmarkProvider>().initList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final isLoading = provider.isLoading;
    final bookList = provider.getList;
    return MyScaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //lib
          Wrap(
            children: [
              TChip(
                title: 'Book Mark',
                avatar: Icon(Icons.check),
              ),
            ],
          ),

          //list
          isLoading
              ? TLoader()
              : Expanded(
                  child: BookmarkListView(
                    list: bookList,
                    onClick: (book) {
                      //set current
                      currentApyarNotifier.value = ApyarModel.fromPath(
                          '${getSourcePath()}/${book.title}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextReaderScreen(),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
