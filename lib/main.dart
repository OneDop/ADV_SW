import 'package:advsw/navigator/app_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const AdvSwApp());
}

class AdvSwApp extends StatelessWidget {
  const AdvSwApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.theme;
    return MaterialApp.router(
      title: 'ProjectPal',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.interTextTheme(base.textTheme),
      ),
      routerConfig: router,
    );
  }
}
