import 'package:ai_partner/presentation.dart';
import 'package:flutter/material.dart';

class AIPartnerApp extends StatelessWidget {
  const AIPartnerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Partner',
      home: const AIPartnerScreen(),
    );
  }
}
