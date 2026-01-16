import 'package:app_launcher/app_launcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus_platform_interface/platform_interface/share_plus_platform.dart';

void main() {
  group('ShareFailure', () {
    test('supports value comparison', () {
      const shareFailure1 = ShareFailure('error');
      const shareFailure2 = ShareFailure('error');
      expect(shareFailure1, equals(shareFailure2));
    });
  });

  group('ShareLauncher', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('calls shareProvider with text', () async {
      var called = false;

      final shareLauncher = ShareLauncher(
        shareProvider: (ShareParams params) async {
          called = true;
          expect(params.text, equals('text'));
        },
      );

      await shareLauncher.shareText(text: 'text');

      expect(called, isTrue);
    });

    test('throws ShareFailure when shareLauncher throws', () async {
      final shareLauncher = ShareLauncher(
        shareProvider: (ShareParams params) => throw Exception(),
      );

      expect(
        shareLauncher.shareText(text: 'text'),
        throwsA(isA<ShareFailure>()),
      );
    });
  });
}
