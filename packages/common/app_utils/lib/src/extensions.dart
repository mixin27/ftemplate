import 'package:flutter/material.dart';

/// Extensions on BuildContext for easier access to theme
extension AppContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Get keyboard height
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);

  /// Get view insets
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Get device pixel ratio
  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if device is in portrait
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  /// Check if device is in landscape
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Get text direction
  TextDirection get textDirection => Directionality.of(this);

  /// Check if text direction is RTL
  bool get isRTL => textDirection == TextDirection.rtl;

  /// Check if text direction is LTR
  bool get isLTR => textDirection == TextDirection.ltr;

  /// Get text scale factor
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1);

  /// Check if accessibility features are enabled
  bool get accessibleNavigation => MediaQuery.accessibleNavigationOf(this);

  /// Check if bold text is enabled
  bool get boldText => MediaQuery.boldTextOf(this);

  /// Check if animations are disabled
  bool get disableAnimations => MediaQuery.disableAnimationsOf(this);

  /// Check if high contrast is enabled
  bool get highContrast => MediaQuery.highContrastOf(this);

  /// Show snackbar
  void showSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Hide current snackbar
  void hideSnackbar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  /// Show bottom sheet
  Future<T?> showBottomSheet<T>(Widget Function(BuildContext) builder) {
    return showModalBottomSheet<T>(context: this, builder: builder);
  }

  /// Focus node
  FocusNode? get focusNode => FocusScope.of(this);

  /// Request focus
  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }

  /// Unfocus
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Check if has focus
  bool get hasFocus => FocusScope.of(this).hasFocus;
}

/// Extensions on Color for manipulation
extension AppColorExtensions on Color {
  /// Lighten color by amount (0.0 to 1.0)
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0.0 and 1.0');

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Darken color by amount (0.0 to 1.0)
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0.0 and 1.0');

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Saturate color by amount (0.0 to 1.0)
  Color saturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0.0 and 1.0');

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }

  /// Desaturate color by amount (0.0 to 1.0)
  Color desaturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0.0 and 1.0');

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation - amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }

  /// Get complementary color
  Color get complementary {
    final hsl = HSLColor.fromColor(this);
    final hue = (hsl.hue + 180) % 360;

    return hsl.withHue(hue).toColor();
  }

  /// Get analogous colors
  List<Color> get analogous {
    final hsl = HSLColor.fromColor(this);
    return [
      hsl.withHue((hsl.hue + 30) % 360).toColor(),
      this,
      hsl.withHue((hsl.hue - 30) % 360).toColor(),
    ];
  }

  /// Get triadic colors
  List<Color> get triadic {
    final hsl = HSLColor.fromColor(this);
    return [
      this,
      hsl.withHue((hsl.hue + 120) % 360).toColor(),
      hsl.withHue((hsl.hue + 240) % 360).toColor(),
    ];
  }

  /// Convert to hex string
  String toHex({bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${(a * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
              '${(r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
              '${(g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
              '${(b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
    }

    return '#${(r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
            '${(g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
            '${(b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  /// Get luminance
  double get luminance => computeLuminance();

  /// Check if color is light
  bool get isLight => luminance > 0.5;

  /// Check if color is dark
  bool get isDark => luminance <= 0.5;

  /// Get contrasting color (black or white)
  Color get onColor => isLight ? Colors.black : Colors.white;

  /// Mix with another color
  Color mix(Color other, [double amount = 0.5]) {
    assert(amount >= 0 && amount <= 1, 'amount must be between 0.0 and 1.0');

    final mred = (r * 255.0).round().clamp(0, 255);
    final mgreen = (g * 255.0).round().clamp(0, 255);
    final mblue = (b * 255.0).round().clamp(0, 255);
    final malpha = (a * 255.0).round().clamp(0, 255);

    final rv =
        (mred + ((other.r * 255.0).round().clamp(0, 255) - mred) * amount)
            .round();
    final gv =
        (mgreen + ((other.g * 255.0).round().clamp(0, 255) - mgreen) * amount)
            .round();
    final bv =
        (mblue + ((other.b * 255.0).round().clamp(0, 255) - mblue) * amount)
            .round();
    final av =
        (malpha + ((other.a * 255.0).round().clamp(0, 255) - malpha) * amount)
            .round();

    return Color.fromARGB(av, rv, gv, bv);
  }

  /// Create color from hex string
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Adjust color temperature (positive = warmer, negative = cooler)
  Color adjustTemperature(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hue = (hsl.hue + amount * 30).clamp(0.0, 360.0);
    return hsl.withHue(hue).toColor();
  }

  /// Create tint (mix with white)
  Color tint([double amount = 0.1]) {
    return mix(Colors.white, amount);
  }

  /// Create shade (mix with black)
  Color shade([double amount = 0.1]) {
    return mix(Colors.black, amount);
  }

  /// Invert color
  Color get inverted {
    return Color.fromARGB(
      (a * 255.0).round().clamp(0, 255),
      255 - (r * 255.0).round().clamp(0, 255),
      255 - (g * 255.0).round().clamp(0, 255),
      255 - (b * 255.0).round().clamp(0, 255),
    );
  }

  /// Get grayscale version
  Color get grayscale {
    final gray =
        (0.299 * (r * 255.0).round().clamp(0, 255) +
                0.587 * (g * 255.0).round().clamp(0, 255) +
                0.114 * (b * 255.0).round().clamp(0, 255))
            .round();
    return Color.fromARGB((a * 255.0).round().clamp(0, 255), gray, gray, gray);
  }

  /// Check contrast ratio with another color
  double contrastWith(Color other) {
    final l1 = luminance;
    final l2 = other.luminance;

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast is sufficient for text (WCAG AA)
  bool hasGoodContrastWith(Color background, {bool largeText = false}) {
    final ratio = contrastWith(background);
    return largeText ? ratio >= 3.0 : ratio >= 4.5;
  }
}

/// Extensions on HSLColor
extension HSLColorExtensions on HSLColor {
  /// Convert to hex string
  String toHex({bool includeAlpha = false}) {
    return toColor().toHex(includeAlpha: includeAlpha);
  }
}

/// Extensions on String for color parsing
extension ColorStringExtensions on String {
  /// Parse hex color string
  Color? toColor() {
    try {
      return AppColorExtensions.fromHex(this);
    } on Exception catch (_) {
      return null;
    }
  }
}
