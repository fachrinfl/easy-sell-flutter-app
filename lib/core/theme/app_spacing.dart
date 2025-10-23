import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double base = 4.0;

  static const double xs = base; // 4px
  static const double sm = base * 2; // 8px
  static const double md = base * 3; // 12px
  static const double lg = base * 4; // 16px
  static const double xl = base * 5; // 20px
  static const double xl2 = base * 6; // 24px
  static const double xl3 = base * 8; // 32px
  static const double xl4 = base * 10; // 40px
  static const double xl5 = base * 12; // 48px
  static const double xl6 = base * 16; // 64px

  static const double s4 = base; // 4px
  static const double s6 = base * 1.5; // 6px
  static const double s8 = base * 2; // 8px

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXl2 = EdgeInsets.all(xl2);
  static const EdgeInsets paddingXl3 = EdgeInsets.all(xl3);

  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXl2 = EdgeInsets.symmetric(horizontal: xl2);

  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVerticalXl2 = EdgeInsets.symmetric(vertical: xl2);

  static const EdgeInsets paddingTopXs = EdgeInsets.only(top: xs);
  static const EdgeInsets paddingTopSm = EdgeInsets.only(top: sm);
  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets paddingTopLg = EdgeInsets.only(top: lg);
  static const EdgeInsets paddingTopXl = EdgeInsets.only(top: xl);
  static const EdgeInsets paddingTopXl2 = EdgeInsets.only(top: xl2);

  static const EdgeInsets paddingBottomXs = EdgeInsets.only(bottom: xs);
  static const EdgeInsets paddingBottomSm = EdgeInsets.only(bottom: sm);
  static const EdgeInsets paddingBottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingBottomLg = EdgeInsets.only(bottom: lg);
  static const EdgeInsets paddingBottomXl = EdgeInsets.only(bottom: xl);
  static const EdgeInsets paddingBottomXl2 = EdgeInsets.only(bottom: xl2);

  static const EdgeInsets paddingLeftXs = EdgeInsets.only(left: xs);
  static const EdgeInsets paddingLeftSm = EdgeInsets.only(left: sm);
  static const EdgeInsets paddingLeftMd = EdgeInsets.only(left: md);
  static const EdgeInsets paddingLeftLg = EdgeInsets.only(left: lg);
  static const EdgeInsets paddingLeftXl = EdgeInsets.only(left: xl);
  static const EdgeInsets paddingLeftXl2 = EdgeInsets.only(left: xl2);

  static const EdgeInsets paddingRightXs = EdgeInsets.only(right: xs);
  static const EdgeInsets paddingRightSm = EdgeInsets.only(right: sm);
  static const EdgeInsets paddingRightMd = EdgeInsets.only(right: md);
  static const EdgeInsets paddingRightLg = EdgeInsets.only(right: lg);
  static const EdgeInsets paddingRightXl = EdgeInsets.only(right: xl);
  static const EdgeInsets paddingRightXl2 = EdgeInsets.only(right: xl2);

  static const EdgeInsets marginXs = EdgeInsets.all(xs);
  static const EdgeInsets marginSm = EdgeInsets.all(sm);
  static const EdgeInsets marginMd = EdgeInsets.all(md);
  static const EdgeInsets marginLg = EdgeInsets.all(lg);
  static const EdgeInsets marginXl = EdgeInsets.all(xl);
  static const EdgeInsets marginXl2 = EdgeInsets.all(xl2);
  static const EdgeInsets marginXl3 = EdgeInsets.all(xl3);

  static const EdgeInsets marginHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets marginHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets marginHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets marginHorizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets marginHorizontalXl2 = EdgeInsets.symmetric(horizontal: xl2);

  static const EdgeInsets marginVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets marginVerticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets marginVerticalXl2 = EdgeInsets.symmetric(vertical: xl2);

  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;
  static const double gapXl2 = xl2;
  static const double gapXl3 = xl3;

  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXl2 = 20.0;
  static const double radiusXl3 = 24.0;
  static const double radiusFull = 999.0;

  static const BorderRadius radiusXsAll = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius radiusSmAll = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius radiusMdAll = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius radiusLgAll = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius radiusXlAll = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius radiusXl2All = BorderRadius.all(Radius.circular(radiusXl2));
  static const BorderRadius radiusXl3All = BorderRadius.all(Radius.circular(radiusXl3));
  static const BorderRadius radiusFullAll = BorderRadius.all(Radius.circular(radiusFull));

  static const double sizeXs = 16.0;
  static const double sizeSm = 24.0;
  static const double sizeMd = 32.0;
  static const double sizeLg = 40.0;
  static const double sizeXl = 48.0;
  static const double sizeXl2 = 56.0;
  static const double sizeXl3 = 64.0;
  static const double sizeXl4 = 72.0;
  static const double sizeXl5 = 80.0;
  static const double sizeXl6 = 96.0;

  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 28.0;
  static const double iconXl2 = 32.0;
  static const double iconXl3 = 36.0;
  static const double iconXl4 = 40.0;
  static const double iconXl5 = 48.0;

  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  static const double inputHeightSm = 36.0;
  static const double inputHeightMd = 44.0;
  static const double inputHeightLg = 52.0;

  static const double appBarHeight = 56.0;

  static const double bottomNavHeight = 60.0;

  static const double fabSize = 56.0;
  static const double fabSmallSize = 40.0;
  static const double fabLargeSize = 64.0;
}
