import 'package:advsw/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( AdvSwApp());
}

class AdvSwApp extends StatelessWidget {
   AdvSwApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADV SW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: LoginScreen(),
    );
  }
}
