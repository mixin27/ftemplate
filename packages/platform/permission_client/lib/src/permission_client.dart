import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart'
    show PermissionStatus, PermissionStatusGetters;

/// {@template permission_client}
/// A client that handles requesting permissions on a device.
/// {@endtemplate}
class PermissionClient {
  /// {@macro permission_client}
  const PermissionClient();

  /// Request access to the device's notifications,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestNotifications() =>
      Permission.notification.request();

  /// Returns a permission status for the device's notifications.
  Future<PermissionStatus> notificationsStatus() =>
      Permission.notification.status;

  /// Request access to the device's camera,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestCamera() => Permission.camera.request();

  /// Returns a permission status for the device's camera.
  Future<PermissionStatus> cameraStatus() => Permission.camera.status;

  /// Request access to the device's storage,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestStorage() => Permission.storage.request();

  /// Returns a permission status for the device's storage.
  Future<PermissionStatus> storageStatus() => Permission.storage.status;

  /// Request access to the device's location,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestLocation() => Permission.location.request();

  /// Returns a permission status for the device's location.
  Future<PermissionStatus> locationStatus() => Permission.location.status;

  /// Request access to the device's microphone,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestMicrophone() =>
      Permission.microphone.request();

  /// Returns a permission status for the device's microphone.
  Future<PermissionStatus> microphoneStatus() => Permission.microphone.status;

  /// Request access to the device's media library,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestMediaLibrary() =>
      Permission.mediaLibrary.request();

  /// Returns a permission status for the device's media library.
  Future<PermissionStatus> mediaLibraryStatus() =>
      Permission.mediaLibrary.status;

  /// Opens the app settings page.
  ///
  /// Returns true if the settings could be opened, otherwise false.
  Future<bool> openPermissionSettings() => openAppSettings();
}
