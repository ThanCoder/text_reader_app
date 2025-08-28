import 'package:flutter/material.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/screens/text_reader/text_reader_screen.dart';

void goRoute(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
}) {
  Navigator.push(context, MaterialPageRoute(builder: builder));
}

void goTextReader(BuildContext context, {required Post post}) {
  goRoute(context, builder: (context) => TextReaderScreen(post: post));
}

// void goEditPostScreen(BuildContext context,Post post,){
//   Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
// }
