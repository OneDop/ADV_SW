import 'package:advsw/navigator/app_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    const ProviderScope(
      child: AdvSwApp(),
    ),
  );
}

class AdvSwApp extends ConsumerWidget {
  const AdvSwApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'ProjectPal',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.darkTheme.textTheme),
      ),
      routerConfig: router,
    );
  }
}

// pfp doesnt show after login, need to check if the user data is being fetched correctly and if the image URL is correct. Also check if the Image widget is handling errors properly (e.g. showing a placeholder if the image fails to load).
// web socket connection is not working, need to check backend logs and flutter logs to debug
// enum name mismatch in message model and backend response, need to standardize on snake_case or camelCase across the board to avoid confusion and bugs.
