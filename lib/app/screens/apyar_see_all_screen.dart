import 'package:apyar/app/components/apyar_grid_item.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/route_helper.dart';
import 'package:flutter/material.dart';

import '../widgets/core/index.dart';

class ApyarSeeAllScreen extends StatelessWidget {
  String title;
  List<ApyarModel> list;
  ApyarSeeAllScreen({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 200,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) => ApyarGridItem(
          apyar: list[index],
          onClicked: (apyar) {
            goTextReaderScreen(context, apyar);
          },
        ),
      ),
    );
  }
}
