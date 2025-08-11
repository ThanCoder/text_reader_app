import 'package:flutter/material.dart';

void goRoute(BuildContext context,
    {required Widget Function(BuildContext context) builder}) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ));
}

// void goEditPostScreen(BuildContext context,PostModel post,){
//   Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
// }
