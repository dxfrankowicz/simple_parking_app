import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_parking_app/pages/map/map_page.dart';
import 'package:simple_parking_app/utils/di/di.dart' as di;
import 'constants/strings.dart';
import 'generated/l10n.dart';

void main() {
  startApp();
}

void startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: Strings.APP_NAME,
      home: MapPage(),
    );
  }
}