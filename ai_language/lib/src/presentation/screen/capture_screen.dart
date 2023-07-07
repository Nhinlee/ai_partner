import 'package:flutter/material.dart';

class CaptureImageScreen extends StatefulWidget {
  const CaptureImageScreen({Key? key}) : super(key: key);

  @override
  State<CaptureImageScreen> createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Language App'),
      ),
      body: Center(
        child: Text('Capture Image Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
