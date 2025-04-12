import 'package:apyar/app/models/apyar_model.dart';
import 'package:flutter/material.dart';

class ApyarListItem extends StatelessWidget {
  ApyarModel apyar;
  void Function(ApyarModel apyar) onClicked;
  ApyarListItem({
    super.key,
    required this.apyar,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(apyar.title),
      onTap: () => onClicked(apyar),
    );
  }
}
