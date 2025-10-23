import 'package:flutter/material.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';

class AppLayout {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppSizes.mobileBreakpoint && width < AppSizes.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.desktopBreakpoint;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double availableWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - (AppSpacing.s4 * 2);
  }

  static double availableHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - 
           MediaQuery.of(context).padding.top - 
           MediaQuery.of(context).padding.bottom;
  }

  static int getGridCrossAxisCount(BuildContext context, {double itemWidth = 200}) {
    final availableWidth = AppLayout.availableWidth(context);
    return (availableWidth / itemWidth).floor().clamp(1, 6);
  }

  static double getGridChildAspectRatio(BuildContext context, {double itemWidth = 200, double itemHeight = 150}) {
    return itemWidth / itemHeight;
  }

  static BoxConstraints getCardConstraints(BuildContext context) {
    return BoxConstraints(
      minWidth: AppSizes.gridItemMinWidth,
      maxWidth: AppSizes.gridItemMaxWidth,
      minHeight: AppSizes.gridItemMinHeight,
      maxHeight: AppSizes.gridItemMaxHeight,
    );
  }

  static BoxConstraints getButtonConstraints(BuildContext context) {
    return BoxConstraints(
      minHeight: AppSizes.buttonHeight,
      maxHeight: AppSizes.buttonHeightLarge,
    );
  }

  static BoxConstraints getInputConstraints(BuildContext context) {
    return BoxConstraints(
      minHeight: AppSizes.inputHeight,
      maxHeight: AppSizes.inputHeightLarge,
    );
  }

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double getTopPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getLeftPadding(BuildContext context) {
    return MediaQuery.of(context).padding.left;
  }

  static double getRightPadding(BuildContext context) {
    return MediaQuery.of(context).padding.right;
  }

  static double getContentHeight(BuildContext context) {
    return screenHeight(context) - 
           getTopPadding(context) - 
           getBottomPadding(context) - 
           AppSizes.appBarHeight;
  }

  static double getContentHeightWithBottomNav(BuildContext context) {
    return getContentHeight(context) - AppSizes.bottomNavHeight;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppSpacing.s4);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(AppSpacing.s6);
    } else {
      return const EdgeInsets.all(AppSpacing.s8);
    }
  }

  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: AppSpacing.s4);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: AppSpacing.s6);
    } else {
      return const EdgeInsets.symmetric(horizontal: AppSpacing.s8);
    }
  }

  static EdgeInsets getResponsiveVerticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(vertical: AppSpacing.s4);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: AppSpacing.s6);
    } else {
      return const EdgeInsets.symmetric(vertical: AppSpacing.s8);
    }
  }

  static Widget buildResponsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    double itemWidth = 200,
    double spacing = 16,
  }) {
    final crossAxisCount = getGridCrossAxisCount(context, itemWidth: itemWidth);
    final childAspectRatio = getGridChildAspectRatio(context, itemWidth: itemWidth);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  static Widget buildResponsiveList({
    required BuildContext context,
    required List<Widget> children,
    double? itemHeight,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemExtent: itemHeight,
      itemBuilder: (context, index) => children[index],
    );
  }

  static double getModalWidth(BuildContext context) {
    final screenWidth = AppLayout.screenWidth(context);
    if (isMobile(context)) {
      return screenWidth * 0.9;
    } else if (isTablet(context)) {
      return screenWidth * 0.7;
    } else {
      return screenWidth * 0.5;
    }
  }

  static double getModalHeight(BuildContext context) {
    final screenHeight = AppLayout.screenHeight(context);
    if (isMobile(context)) {
      return screenHeight * 0.8;
    } else if (isTablet(context)) {
      return screenHeight * 0.7;
    } else {
      return screenHeight * 0.6;
    }
  }

  static double getDrawerWidth(BuildContext context) {
    if (isMobile(context)) {
      return screenWidth(context) * 0.8;
    } else {
      return AppSizes.drawerWidth;
    }
  }

  static double getBottomSheetHeight(BuildContext context, {double ratio = 0.5}) {
    return screenHeight(context) * ratio;
  }

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
