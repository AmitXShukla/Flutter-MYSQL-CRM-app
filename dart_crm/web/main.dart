import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:dart_crm/main.dart' as app;

main() async {
  await ui.webOnlyInitializePlatform();
  app.main();
}