import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  PreferredSizeWidget? appBar;
  Widget? body;
  Widget? floatingActionButton;
  BoxConstraints? customBoxConstraints;

  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;
  List<Widget>? persistentFooterButtons;
  AlignmentDirectional persistentFooterAlignment;
  Widget? drawer;
  void Function(bool)? onDrawerChanged;
  Widget? endDrawer;
  void Function(bool)? onEndDrawerChanged;
  Widget? bottomNavigationBar;
  Widget? bottomSheet;
  Color? backgroundColor;
  bool? resizeToAvoidBottomInset;
  bool primary;
  DragStartBehavior drawerDragStartBehavior;
  bool extendBody;
  bool extendBodyBehindAppBar;
  Color? drawerScrimColor;
  double? drawerEdgeDragWidth;
  bool drawerEnableOpenDragGesture;
  bool endDrawerEnableOpenDragGesture;
  String? restorationId;
  MyScaffold({
    super.key,
    required this.body,
    this.customBoxConstraints,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.drawerScrimColor,
    this.endDrawer,
    this.endDrawerEnableOpenDragGesture = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.persistentFooterButtons,
    this.primary = true,
    this.resizeToAvoidBottomInset,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: _getConstractBox(),
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }

  Widget? _getConstractBox() {
    // custom top
    if (customBoxConstraints != null) {
      return Center(
          child:
              ConstrainedBox(constraints: customBoxConstraints!, child: body));
    }
    // all config

    return body;
  }
}
