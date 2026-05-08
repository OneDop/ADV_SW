import 'package:advsw/navigator/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdvSwApp());
}

class AdvSwApp extends StatelessWidget {
  const AdvSwApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ADV SW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      routerConfig: router,
    );
  }
}
