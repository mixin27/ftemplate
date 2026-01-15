import 'package:flutter/material.dart';

/// Responsive utilities for adaptive layouts
class AppResponsiveUtils {
  const AppResponsiveUtils._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopBreakpoint;
  }

  /// Check if current device is large desktop (4K)
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1920;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop;
    }
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get responsive padding
  static double padding(BuildContext context) {
    return value(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );
  }

  /// Get responsive spacing
  static double spacing(BuildContext context) {
    return value(
      context,
      mobile: 8,
      tablet: 16,
      desktop: 24,
    );
  }

  /// Get responsive font size
  static double fontSize(
    BuildContext context, {
    required double base,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: base,
      tablet: tablet ?? base * 1.1,
      desktop: desktop ?? base * 1.2,
    );
  }

  /// Get responsive grid column count
  static int gridColumns(BuildContext context) {
    return value(context, mobile: 1, tablet: 2, desktop: 3, largeDesktop: 4);
  }

  /// Get responsive max width for content
  static double maxWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 768,
      desktop: 1200,
    );
  }

  /// Check if device is portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  /// Check if device is landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  /// Get device pixel ratio
  static double pixelRatio(BuildContext context) {
    return MediaQuery.devicePixelRatioOf(context);
  }

  /// Get safe area padding
  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  /// Get screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  }

  /// Get keyboard height
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom;
  }
}

/// Extension on BuildContext for easier responsive access
extension ResponsiveContext on BuildContext {
  /// Check if mobile
  bool get isMobile => AppResponsiveUtils.isMobile(this);

  /// Check if tablet
  bool get isTablet => AppResponsiveUtils.isTablet(this);

  /// Check if desktop
  bool get isDesktop => AppResponsiveUtils.isDesktop(this);

  /// Get responsive padding
  double get responsivePadding => AppResponsiveUtils.padding(this);

  /// Get responsive spacing
  double get responsiveSpacing => AppResponsiveUtils.spacing(this);

  /// Get screen width
  double get screenWidth => AppResponsiveUtils.screenWidth(this);

  /// Get screen height
  double get screenHeight => AppResponsiveUtils.screenHeight(this);

  /// Check if portrait
  bool get isPortrait => AppResponsiveUtils.isPortrait(this);

  /// Check if landscape
  bool get isLandscape => AppResponsiveUtils.isLandscape(this);
}

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: builder);
  }
}

/// Responsive layout with different widgets per breakpoint
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (AppResponsiveUtils.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (AppResponsiveUtils.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive grid
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final columns = AppResponsiveUtils.value(
      context,
      mobile: mobileColumns!,
      tablet: tabletColumns ?? mobileColumns!,
      desktop: desktopColumns ?? tabletColumns ?? mobileColumns!,
    );

    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: runSpacing,
      crossAxisSpacing: spacing,
      childAspectRatio: childAspectRatio ?? 1.0,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}

/// Sliver version of ResponsiveGrid (recommended for performance)
class ResponsiveSliverGrid extends StatelessWidget {
  const ResponsiveSliverGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1.0,
  });

  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final columns = AppResponsiveUtils.value(
      context,
      mobile: mobileColumns!,
      tablet: tabletColumns ?? mobileColumns!,
      desktop: desktopColumns ?? tabletColumns ?? mobileColumns!,
    );

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: runSpacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
}

/// Responsive Wrap - Best performance for grids inside ScrollView
/// Uses Wrap widget which naturally flows without shrinkWrap
class ResponsiveWrapGrid extends StatelessWidget {
  const ResponsiveWrapGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.itemHeight,
  });

  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? itemHeight;

  @override
  Widget build(BuildContext context) {
    final columns = AppResponsiveUtils.value(
      context,
      mobile: mobileColumns!,
      tablet: tabletColumns ?? mobileColumns!,
      desktop: desktopColumns ?? tabletColumns ?? mobileColumns!,
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final padding = AppResponsiveUtils.padding(context);

    // Calculate item width
    final availableWidth =
        screenWidth - (padding * 2) - (spacing * (columns - 1));
    final itemWidth = availableWidth / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        Widget wrappedChild = SizedBox(
          width: columns == 1 ? double.infinity : itemWidth,
          child: child,
        );

        if (itemHeight != null) {
          wrappedChild = SizedBox(
            width: columns == 1 ? double.infinity : itemWidth,
            height: itemHeight,
            child: child,
          );
        }

        return wrappedChild;
      }).toList(),
    );
  }
}

/// Responsive wrap
class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    required this.children,
    super.key,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: children,
    );
  }
}

/// Responsive row/column switcher
class ResponsiveFlexible extends StatelessWidget {
  const ResponsiveFlexible({
    required this.children,
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.reverseOnMobile = false,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool reverseOnMobile;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsiveUtils.isMobile(context);
    final effectiveChildren = (isMobile && reverseOnMobile)
        ? children.reversed.toList()
        : children;

    if (isMobile) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: effectiveChildren,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: effectiveChildren,
    );
  }
}
