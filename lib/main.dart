import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A6592);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chrono Class',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
      ),
      home: const LoginPage(),
    );
  }
}