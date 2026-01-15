import 'package:url_launcher/url_launcher.dart';

/// {@template app_launcher_exception}
/// Exceptions from the app launcher.
/// {@endtemplate}
abstract class AppLauncherException implements Exception {
  /// {@macro app_launcher_exception}
  const AppLauncherException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template launch_app_failure}
/// Thrown during the launching app process if a failure occurs.
/// {@endtemplate}
class UrlAppLaunchFailure extends AppLauncherException {
  /// {@macro launch_app_failure}
  const UrlAppLaunchFailure(super.error);
}

/// Provider to inject `launchUrl`.
typedef LaunchUrlProvider = Future<bool> Function(Uri url);

/// Provider to inject `canLaunchUrl`.
typedef CanLaunchUrlProvider = Future<bool> Function(Uri url);

/// {@template app_launcher}
/// Class which manages the app launcher logic.
/// {@endtemplate}
class AppLauncher {
  /// {@macro app_launcher}
  AppLauncher({
    LaunchUrlProvider? launchUrlProvider,
    CanLaunchUrlProvider? canLaunchUrlProvider,
  }) : _launchUrlProvider = launchUrlProvider ?? launchUrl,
       _canLaunchUrlProvider = canLaunchUrlProvider ?? canLaunchUrl;

  final LaunchUrlProvider _launchUrlProvider;
  final CanLaunchUrlProvider _canLaunchUrlProvider;

  /// Launches the app with the given URL.
  ///
  /// Returns true if the app was launched successfully, otherwise either
  /// returns false or throws a [UrlAppLaunchFailure] depending on the failure.
  Future<void> launch(Uri url) async {
    try {
      if (await _canLaunchUrlProvider(url)) {
        await _launchUrlProvider(url);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UrlAppLaunchFailure(error), stackTrace);
    }
  }
}
