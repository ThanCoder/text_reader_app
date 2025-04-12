import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';

class ApyarGridItem extends StatelessWidget {
  ApyarModel apyar;
  void Function(ApyarModel apyar) onClicked;
  ApyarGridItem({
    super.key,
    required this.apyar,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(apyar),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: MyImageFile(
                    path: apyar.coverPath,
                    // fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(178, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  apyar.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
