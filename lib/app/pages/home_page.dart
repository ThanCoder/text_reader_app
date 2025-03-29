import 'dart:io';

import 'package:apyar/app/components/apyar_list_view.dart';
import 'package:apyar/app/customs/apyar_search_delegate.dart';
import 'package:apyar/app/notifiers/apyar_notifier.dart';
import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/screens/text_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/index.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApyarProvider>();
    final isLoading = provider.isLoading;
    final apyarList = provider.getList;
    return MyScaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ApyarSearchDelegate(list: apyarList),
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
              : Container(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : RefreshIndicator(
              onRefresh: () async {
                context.read<ApyarProvider>().initList(isReset: true);
              },
              child: ApyarListView(
                list: apyarList,
                onClick: (apyar) {
                  //set current
                  currentApyarNotifier.value = apyar;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextReaderScreen(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
