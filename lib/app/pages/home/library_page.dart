import 'package:apyar/app/components/apyar_grid_item.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:apyar/app/route_helper.dart';
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
    await context.read<BookmarkProvider>().initList(isReset: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;
    return MyScaffold(
        appBar: AppBar(
          title: Text('Library'),
        ),
        body: isLoading
            ? TLoader()
            : GridView.builder(
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  mainAxisExtent: 160,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) => ApyarGridItem(
                  apyar: list[index],
                  onClicked: (apyar) => goTextReaderScreen(context, apyar),
                ),
              ));
  }
}
