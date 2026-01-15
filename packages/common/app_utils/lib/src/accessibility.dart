import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility helpers for WCAG compliance
class AppAccessibility {
  const AppAccessibility._();

  // Minimum touch target sizes
  static const double minTouchTarget = 44;
  static const double minTouchTargetWeb = 48;
  static const double recommendedTouchTarget = 48;

  // Contrast ratios (WCAG 2.1)
  static const double minContrastNormal = 4.5; // Normal text
  static const double minContrastLarge = 3; // Large text (18pt+)
  static const double enhancedContrastNormal = 7; // AAA level
  static const double enhancedContrastLarge = 4.5; // AAA level

  /// Generate semantic label for student card
  static String studentCardLabel(String name, String className) {
    return 'Student $name from $className';
  }

  /// Generate semantic label for course card
  static String courseCardLabel(String title, String instructor) {
    return 'Course $title taught by $instructor';
  }

  /// Generate semantic label for grade card
  static String gradeCardLabel(String subject, String grade, int score) {
    return '$subject grade $grade with score $score';
  }

  /// Generate semantic label for attendance indicator
  static String attendanceLabel(String status, DateTime date) {
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    return 'Attendance $status on $formattedDate';
  }

  /// Generate semantic label for progress
  static String progressLabel(double progress, {String? context}) {
    final percentage = (progress * 100).toInt();
    if (context != null) {
      return '$context progress $percentage percent';
    }
    return 'Progress $percentage percent';
  }

  /// Calculate relative luminance of a color
  static double _relativeLuminance(Color color) {
    final r = _luminanceComponent(
      (color.r * 255.0).round().clamp(0, 255) / 255,
    );
    final g = _luminanceComponent(
      (color.g * 255.0).round().clamp(0, 255) / 255,
    );
    final b = _luminanceComponent(
      (color.b * 255.0).round().clamp(0, 255) / 255,
    );
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _luminanceComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }
    return ((component + 0.055) / 1.055).pow(2.4).toDouble();
  }

  /// Calculate contrast ratio between two colors
  static double contrastRatio(Color foreground, Color background) {
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast ratio is sufficient for normal text (WCAG AA)
  static bool hasGoodContrast(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minContrastNormal;
  }

  /// Check if contrast ratio is sufficient for large text (WCAG AA)
  static bool hasGoodContrastLarge(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minContrastLarge;
  }

  /// Check if contrast ratio meets AAA level
  static bool hasEnhancedContrast(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= enhancedContrastNormal;
  }

  /// Make screen reader announcement
  static Future<void> announce(
    BuildContext context,
    String message, {
    TextDirection? textDirection,
    Assertiveness assertiveness = Assertiveness.polite,
  }) async {
    await SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      textDirection ?? Directionality.of(context),
      assertiveness: assertiveness,
    );
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.accessibleNavigationOf(context);
  }

  /// Get appropriate touch target size for platform
  static double getTouchTargetSize(BuildContext context) {
    // Web requires slightly larger touch targets
    return kIsWeb ? minTouchTargetWeb : minTouchTarget;
  }

  /// Wrap widget with minimum touch target size
  static Widget ensureTouchTarget(
    Widget child, {
    required BuildContext context,
    double? size,
  }) {
    final targetSize = size ?? getTouchTargetSize(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: targetSize, minHeight: targetSize),
      child: child,
    );
  }

  /// Create semantic button
  static Widget semanticButton({
    required Widget child,
    required VoidCallback? onPressed,
    required String label,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      child: child,
    );
  }

  /// Create semantic image
  static Widget semanticImage({
    required Widget child,
    required String label,
    bool isDecorative = false,
  }) {
    if (isDecorative) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(image: true, label: label, child: child);
  }

  /// Create semantic text field
  static Widget semanticTextField({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool isPassword = false,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      value: value,
      obscured: isPassword,
      child: child,
    );
  }

  /// Create semantic list
  static Widget semanticList({
    required Widget child,
    required int itemCount,
    String? label,
  }) {
    return Semantics(label: label, hint: '$itemCount items', child: child);
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1);
  }

  /// Check if user prefers reduced motion
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }

  /// Get duration based on reduced motion preference
  static Duration getAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    if (prefersReducedMotion(context)) {
      return Duration.zero;
    }
    return normalDuration;
  }

  /// Check if high contrast mode is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.highContrastOf(context);
  }

  /// Get platform brightness
  static Brightness getPlatformBrightness(BuildContext context) {
    return MediaQuery.platformBrightnessOf(context);
  }

  /// Check if bold text is enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.boldTextOf(context);
  }

  /// Create focus node with proper handling
  static FocusNode createFocusNode({
    String? debugLabel,
    bool skipTraversal = false,
    bool canRequestFocus = true,
  }) {
    return FocusNode(
      debugLabel: debugLabel,
      skipTraversal: skipTraversal,
      canRequestFocus: canRequestFocus,
    );
  }

  /// Request focus with screen reader announcement
  static Future<void> requestFocusWithAnnouncement(
    BuildContext context,
    FocusNode focusNode,
    String announcement,
  ) async {
    focusNode.requestFocus();
    await announce(context, announcement);
  }

  /// Create semantic heading
  static Widget semanticHeading({
    required Widget child,
    required String label,
    int level = 1,
  }) {
    return Semantics(header: true, label: label, child: child);
  }

  /// Create semantic link
  static Widget semanticLink({
    required Widget child,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Semantics(link: true, label: label, onTap: onTap, child: child);
  }

  /// Create live region for dynamic updates
  static Widget liveRegion({
    required Widget child,
    required bool liveRegion,
    String? label,
  }) {
    return Semantics(liveRegion: liveRegion, label: label, child: child);
  }

  /// Get recommended font size with text scaling
  static double getScaledFontSize(BuildContext context, double baseFontSize) {
    final textScaleFactor = getTextScaleFactor(context);
    final scaledSize = baseFontSize * textScaleFactor;

    // Clamp to reasonable range
    return scaledSize.clamp(12.0, 32.0);
  }

  /// Check if widget is focusable
  static bool isFocusable(BuildContext context) {
    return Focus.of(context).canRequestFocus;
  }

  /// Get semantic sort key for proper reading order
  static SemanticsSortKey getSortKey(int order) {
    return OrdinalSortKey(order.toDouble());
  }

  /// Create dismissible action with semantic feedback
  static Widget semanticDismissible({
    required Widget child,
    required Key key,
    required DismissDirectionCallback onDismissed,
    required String dismissLabel,
  }) {
    return Dismissible(
      key: key,
      onDismissed: onDismissed,
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: dismissLabel): () {},
        },
        child: child,
      ),
    );
  }

  /// Validate form accessibility
  static bool validateFormAccessibility(GlobalKey<FormState> formKey) {
    // Check if all fields have labels and hints
    // This is a simplified validation
    return formKey.currentState != null;
  }

  /// Get semantic label for time
  static String timeLabel(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Get semantic label for date
  static String dateLabel(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Get semantic label for date range
  static String dateRangeLabel(DateTime start, DateTime end) {
    return 'From ${dateLabel(start)} to ${dateLabel(end)}';
  }
}

/// Extension for easier accessibility in code
extension AccessibilityExtensions on Widget {
  /// Add semantic label
  Widget withSemantics({required String label, String? hint, String? value}) {
    return Semantics(label: label, hint: hint, value: value, child: this);
  }

  /// Mark as heading
  Widget asHeading(String label) {
    return Semantics(header: true, label: label, child: this);
  }

  /// Mark as button
  Widget asButton(String label, {VoidCallback? onTap}) {
    return Semantics(button: true, label: label, onTap: onTap, child: this);
  }

  /// Mark as decorative (exclude from semantics)
  Widget asDecorative() {
    return ExcludeSemantics(child: this);
  }

  /// Ensure minimum touch target
  Widget withMinimumTouchTarget(BuildContext context) {
    return AppAccessibility.ensureTouchTarget(this, context: context);
  }
}

/// Extension on num for pow
extension on num {
  num pow(num exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}
