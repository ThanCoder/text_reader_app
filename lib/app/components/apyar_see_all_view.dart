import 'package:apyar/app/components/apyar_grid_item.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:flutter/material.dart';

class ApyarSeeAllView extends StatelessWidget {
  List<ApyarModel> list;
  String title;
  int showCount;
  void Function(String title, List<ApyarModel> list) onSeeAllClicked;
  void Function(ApyarModel novel) onClicked;
  EdgeInsetsGeometry? margin;

  ApyarSeeAllView({
    super.key,
    required this.title,
    required this.list,
    required this.onSeeAllClicked,
    required this.onClicked,
    this.showCount = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final showList = list.take(showCount).toList();
    if (showList.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      margin: margin,
      child: SizedBox(
        height: 270,
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                GestureDetector(
                  onTap: () => onSeeAllClicked(title, list),
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: showList.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 130,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemBuilder: (context, index) => ApyarGridItem(
                  apyar: showList[index],
                  onClicked: onClicked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
