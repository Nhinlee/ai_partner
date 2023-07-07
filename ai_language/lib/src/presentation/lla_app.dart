import 'package:ai_language/presetation.dart';
import 'package:flutter/material.dart';

class LLAApp extends StatelessWidget {
  const LLAApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LLA - Language Learning App',
      home: CaptureImageScreen(),
    );
  }
}
