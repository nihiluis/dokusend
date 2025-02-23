import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dokusend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF567FFC),
        ).copyWith(
          primary: const Color(0xFF567FFC),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Dokusend'),
    );
  }
}
