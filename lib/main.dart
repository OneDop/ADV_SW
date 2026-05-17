import 'package:advsw/navigator/app_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.instance.init();
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
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (_, _) {
        final light = AppTheme.theme;
        final dark  = AppTheme.darkTheme;
        return MaterialApp.router(
          title: 'ProjectPal',
          debugShowCheckedModeBanner: false,
          theme:     light.copyWith(textTheme: GoogleFonts.interTextTheme(light.textTheme)),
          darkTheme: dark.copyWith(textTheme: GoogleFonts.interTextTheme(dark.textTheme)),
          themeMode: ThemeManager.instance.mode,
          routerConfig: router,
        );
      },
    );
  }
}
