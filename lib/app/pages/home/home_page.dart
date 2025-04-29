import 'dart:io';

import 'package:apyar/app/action_button/apyar_add_button.dart';
import 'package:apyar/app/components/apyar_see_all_view.dart';
import 'package:apyar/app/customs/apyar_search.dart';
import 'package:apyar/app/drawers/home_drawer.dart';
import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:apyar/app/route_helper.dart';
import 'package:apyar/app/screens/apyar_see_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    await context.read<ApyarProvider>().initList();
    if (!mounted) return;
    await context.read<BookmarkProvider>().initList(isReset: true);
  }

  void _goSeeAllScreen(String title, List<ApyarModel> list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApyarSeeAllScreen(title: title, list: list),
      ),
    );
  }

  Widget _getListWidget(List<ApyarModel> list) {
    final randomList = List.of(list);
    randomList.shuffle();

    final bookList = context.watch<BookmarkProvider>().getList;

    return CustomScrollView(
      slivers: [
        // app bar
        SliverAppBar(
          title: Text(appName),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ApyarSearch(list: list),
                );
              },
              icon: const Icon(Icons.search),
            ),
            //linux
            Platform.isLinux
                ? IconButton(
                    onPressed: () async {
                      context.read<ApyarProvider>().initList(isReset: true);
                    },
                    icon: const Icon(Icons.refresh),
                  )
                : SizedBox.shrink(),
            ApyarAddButton(),
          ],
        ),
        // Random
        SliverToBoxAdapter(
          child: ApyarSeeAllView(
            margin: EdgeInsets.only(bottom: 10),
            title: 'Random',
            showLines: 1,
            list: randomList,
            onSeeAllClicked: _goSeeAllScreen,
            onClicked: (apyar) => goTextReaderScreen(context, apyar),
          ),
        ),

        // Latest
        SliverToBoxAdapter(
          child: ApyarSeeAllView(
            margin: EdgeInsets.only(bottom: 10),
            title: 'Latest',
            list: list,
            onSeeAllClicked: _goSeeAllScreen,
            onClicked: (apyar) => goTextReaderScreen(context, apyar),
          ),
        ),

        // Book Mark
        SliverToBoxAdapter(
          child: ApyarSeeAllView(
            margin: EdgeInsets.only(bottom: 10),
            showLines: 1,
            title: 'Book Mark',
            list: bookList,
            onSeeAllClicked: _goSeeAllScreen,
            onClicked: (apyar) => goTextReaderScreen(context, apyar),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApyarProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;
    return MyScaffold(
      contentPadding: 0,
      drawer: HomeDrawer(),
      body: isLoading
          ? TLoader()
          : RefreshIndicator(
              onRefresh: () async {
                context.read<ApyarProvider>().initList(isReset: true);
              },
              child: _getListWidget(list),
            ),
    );
  }
}
