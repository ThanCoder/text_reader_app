import 'package:flutter/material.dart';
import 'package:text_reader/app/others/fetcher/types/website.dart';

class WebsiteChooser extends StatelessWidget {
  final Website? value;
  final List<Website> list;
  final void Function(Website value)? onChanged;
  const WebsiteChooser({
    super.key,
    required this.list,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Website>(
      value: value,
      items: _getItems,
      onChanged: (value) => onChanged?.call(value!),
    );
  }

  List<DropdownMenuItem<Website>> get _getItems => list
      .map((e) => DropdownMenuItem<Website>(value: e, child: Text(e.title)))
      .toList();
}
