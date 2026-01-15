import 'package:ftemplate/app/app.dart';
import 'package:ftemplate/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
