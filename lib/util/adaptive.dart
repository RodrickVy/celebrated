import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Adaptive {
  final BuildContext context;
  Adaptive( this.context);
  /// The same of MediaQuery.of(context).size
  Size get mediaQuerySize => MediaQuery.of(context).size;

  /// The same of MediaQuery.of(context).size.height
  /// Note: updates when you resize your screen (like on a browser or desktop window)
  double get height => mediaQuerySize.height;

  /// The same of MediaQuery.of(_context).size.width
  /// Note: updates when you resize your screen (like on a browser or desktop window)
  double get width => mediaQuerySize.width;

  /// Gives you the power to get a portion of the height.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you would get
  /// like for example: if you want a value that represents a third of the screen
  /// you can set it to 3, and you will get a third of the height
  ///
  /// [reducedBy] is a percentage value of how much of the height you want
  /// if you for example want 46% of the height, then you reduce it by 56%.
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.height -
        ((mediaQuerySize.height / 100) * reducedBy)) /
        dividedBy;
  }

  /// Gives you the power to get a portion of the width.
  /// Useful for responsive applications.
  ///
  /// [dividedBy] is for when you want to have a portion of the value you would get
  /// like for example: if you want a value that represents a third of the screen
  /// you can set it to 3, and you will get a third of the width
  ///
  /// [reducedBy] is a percentage value of how much of the width you want
  /// if you for example want 46% of the width, then you reduce it by 56%.
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (mediaQuerySize.width - ((mediaQuerySize.width / 100) * reducedBy)) /
        dividedBy;
  }

  /// Divide the height proportionally by the given value
  double ratio(
      {double dividedBy = 1,
        double reducedByW = 0.0,
        double reducedByH = 0.0}) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  /// similar to MediaQuery.of(_context).padding
  ThemeData get theme => Get.theme;

  /// similar to MediaQuery.of(_context).padding
  TextTheme get textTheme => Get.textTheme;

  IconThemeData get iconTheme => Get.theme.iconTheme;

  /// similar to MediaQuery.of(_context).padding
  EdgeInsets get mediaQueryPadding => Get.mediaQuery.padding;

  /// similar to MediaQuery.of(_context).padding
  MediaQueryData get mediaQuery => Get.mediaQuery;

  MediaQueryData getMediaQuery(BuildContext context) => MediaQuery.of(context);

  /// similar to MediaQuery.of(_context).viewPadding
  EdgeInsets get mediaQueryViewPadding => Get.mediaQuery.viewPadding;

  /// similar to MediaQuery.of(_context).viewInsets
  EdgeInsets get mediaQueryViewInsets => Get.mediaQuery.viewInsets;

  /// similar to MediaQuery.of(_context).orientation
  Orientation get orientation => Get.mediaQuery.orientation;

  /// check if device is on landscape mode
  bool get landscape => orientation == Orientation.landscape;

  /// check if device is on portrait mode
  bool get portrait => orientation == Orientation.portrait;

  /// similar to MediaQuery.of(this).devicePixelRatio
  double get devicePixelRatio => Get.mediaQuery.devicePixelRatio;

  /// similar to MediaQuery.of(this).textScaleFactor
  double get textScaleFactor => Get.mediaQuery.textScaleFactor;

  /// get the shortestSide from screen
  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  /// True if width be larger than 800
  bool get showNavbar => width > 800;

  /// True if the shortestSide is largest than 1220p
  bool get largeDesktop => mediaQueryShortestSide >= 1920;

  /// True if the shortestSide is largest than 1280p
  bool get mediumDesktop => mediaQueryShortestSide >= 128;

  /// True if the shortestSide is largest than 960p
  bool get smallDesktop => mediaQueryShortestSide >= 960;

  /// True if the shortestSide is largest than 720p
  bool get largeTablet => mediaQueryShortestSide >= 720;

  /// True if the shortestSide is largest than 600p
  bool get smallTablet => mediaQueryShortestSide >= 600;

  bool get largePhone => mediaQueryShortestSide <= 600;

  bool get mediumPhone => mediaQueryShortestSide <= 400;

  bool get smallPhone => mediaQueryShortestSide <= 360;

  bool get isPhone => largePhone;

  bool get isTablet => largeTablet;

  bool get isDesktop => largeDesktop;

  bool get isPhonePortrait => largePhone && portrait;

  bool get isPhoneLandscape => largePhone && landscape;

  bool get isTabletPortrait => largeTablet && portrait;

  bool get isTabletLandscape => largeTablet && landscape;

  bool get isDesktopPortrait => largeDesktop && portrait;

  bool get isDesktopLandscape => largeDesktop && landscape;

  /// phone   | portrait  -> normalDrawer ||
  /// phone   | landscape -> flatFullHeightDrawer(minimized -> icons)
  /// tablet  | portrait  -> normalDrawer
  /// tablet  | landscape -> flatFullHeightDrawer(minimized -> icons)
  /// desktop | portrait  -> flatFullHeightDrawer(minimized -> icons)

  T orient<T>({required T port, required T land}) {
    return landscape ? land : port;
  }

  T desktop<T>({required T small, T? medium, T? large}) {
    if (largeDesktop && large != null) {
      return large;
    } else if (mediumDesktop && medium != null) {
      return medium;
    } else {
      return small;
    }
  }

  /// True if the current device is Tablet
  T tablet<T>({required T small, T? large}) {
    if (largeTablet && large != null) {
      return large;
    } else {
      return small;
    }
  }

  T phone<T>({required T small, T? medium, T? large}) {
    if (largePhone && large != null) {
      return large;
    } else if (mediumPhone && medium != null) {
      return medium;
    } else {
      return small;
    }
  }

  T orientationBuilder<T>(
      {required T Function() portrait, required T Function() landscape}) {
    return this.landscape ? landscape() : portrait();
  }

  Y adapt<Y>({required Y phone, required Y tablet, required Y desktop}) {
    if (smallDesktop) {
      return desktop;
    } else if (smallTablet) {
      return tablet;
    } else {
      return phone;
    }
  }

  Y adaptBuilder<Y>(
      {required Y Function() phone,
        required Y Function() tablet,
        required Y Function() desktop}) {
    if (smallDesktop) {
      return desktop();
    } else if (smallTablet) {
      return tablet();
    } else {
      return phone();
    }
  }

  String get adaptState {
    return adapt(
      phone: orient(port: "Phone Portrait", land: "Phone Landscape"),
      tablet: orient(port: "Tablet Portrait", land: "Tablet Landscape"),
      desktop: orient(port: "Desktop Portrait", land: "Desktop Landscape"),
    );
  }



}