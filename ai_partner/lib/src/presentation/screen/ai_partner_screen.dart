import 'package:flutter/material.dart';

class AIPartnerScreen extends StatefulWidget {
  const AIPartnerScreen({Key? key}) : super(key: key);

  @override
  State<AIPartnerScreen> createState() => _AIPartnerScreenState();
}

class _AIPartnerScreenState extends State<AIPartnerScreen> {
  String aiResp = 'Waiting Response ...';
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Partner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "Fill your topic here!"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(aiResp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
