import 'package:flutter/material.dart';

class TestSTTScreen extends StatefulWidget {
  const TestSTTScreen({super.key});

  @override
  State<TestSTTScreen> createState() => _TestSTTScreenState();
}

class _TestSTTScreenState extends State<TestSTTScreen> {
  String textFromSpeaker = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test STT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textFromSpeaker,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Start STT'),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Stop STT'),
            ),
          ],
        ),
      ),
    );
  }
}
