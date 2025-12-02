import 'package:flutter/material.dart';

import 'package:ai_doctor_assistant/ui/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Doctor Assistant',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.cyan)),
      home: const Layout(),
    );
  }
}
