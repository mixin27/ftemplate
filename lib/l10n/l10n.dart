import 'package:flutter/material.dart';
import 'package:ftemplate/l10n/gen/app_localizations.dart';

export 'package:ftemplate/l10n/gen/app_localizations.dart';

/// Extension to access the [AppLocalizations] instance in a [BuildContext].
extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance for the current [BuildContext].
  AppLocalizations get l10n => AppLocalizations.of(this);
}
