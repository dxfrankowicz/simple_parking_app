import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_parking_app/constants/strings.dart';

class BaseScaffold {
  static Widget get(
    BuildContext context, {
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    Widget? endDrawer,
    Widget? botNavBar,
    Widget? bottomSheet,
    Color? backgroundColor,
    GlobalKey? scaffoldKey,
    Widget? title,
    bool centerTitle = true,
    bool? resizeToAvoidBottomInset,
    List<Widget>? actions,
    double elevation = 0,
  }) {
    return AppScaffold(
        scaffoldKey: scaffoldKey,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        endDrawer: endDrawer,
        appBar: appBar ??
            BaseScaffold.appBar(context,
                actions: actions ?? [],
                title: title ?? Text(Strings.APP_NAME),
                centerTitle: centerTitle,
                elevation: elevation),
        drawer: drawer,
        bottomSheet: bottomSheet,
        botNavBar: botNavBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: body);
  }

  static AppBar appBar(BuildContext context,
          {List<Widget>? actions,
          Widget? title,
          bool centerTitle: true,
          double? elevation}) =>
      AppBar(
        centerTitle: centerTitle,
        title: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8), child: title)
                  : Container()
            ],
          ),
        ),
        elevation:
            elevation ?? (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        actions: actions,
      );
}

//ignore: must_be_immutable
class AppScaffold extends StatefulWidget {
  PreferredSizeWidget? appBar;
  Widget? body;
  Widget? floatingActionButton;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;
  List<Widget>? persistentFooterButtons;
  Widget? drawer;
  Widget? endDrawer;
  Widget? botNavBar;
  Widget? bottomSheet;
  Color? backgroundColor;
  GlobalKey? scaffoldKey;
  Widget? title;
  bool centerTitle = true;
  List<Widget>? actions;
  bool? resizeToAvoidBottomInset;
  PreferredSizeWidget? bottom;

  AppScaffold({
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.botNavBar,
    this.bottomSheet,
    this.backgroundColor,
    this.scaffoldKey,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.resizeToAvoidBottomInset = false,
    this.bottom,
  });

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: Platform.isIOS ? false : true,
        key: widget.scaffoldKey ?? _scaffoldKey,
        backgroundColor: widget.backgroundColor,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        endDrawer: widget.endDrawer,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? false,
        appBar: widget.appBar ??
            BaseScaffold.appBar(context,
                actions: widget.actions ?? [],
                title: widget.title ?? Container(),
                centerTitle: widget.centerTitle),
        drawer: widget.drawer,
        bottomSheet: widget.bottomSheet,
        bottomNavigationBar: widget.botNavBar,
        body: widget.body);
  }
}
