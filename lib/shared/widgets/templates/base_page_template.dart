import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_layout.dart';
import '../molecules/app_app_bar.dart';

class BasePageTemplate extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool showAppBar;
  final bool extendBodyBehindAppBar;
  final EdgeInsets? bodyPadding;
  final bool safeArea;

  const BasePageTemplate({
    super.key,
    this.title,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar = true,
    this.extendBodyBehindAppBar = false,
    this.bodyPadding,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.surface,
      appBar: showAppBar
          ? AppAppBar(title: title ?? '', actions: actions)
          : null,
      body: safeArea
          ? SafeArea(
              child: Padding(
                padding: bodyPadding ?? AppLayout.getResponsivePadding(context),
                child: body,
              ),
            )
          : Padding(
              padding: bodyPadding ?? AppLayout.getResponsivePadding(context),
              child: body,
            ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
