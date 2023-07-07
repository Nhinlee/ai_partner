import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImageScreen extends StatefulWidget {
  const CaptureImageScreen({Key? key}) : super(key: key);

  @override
  State<CaptureImageScreen> createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  final _imagePicker = ImagePicker();
  final _englishTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Learning Language App'),
      ),
      body: Center(
        child: Text('Capture Image Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onCaptureImage(),
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImagePreview(File imageFile) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(
            File(imageFile.path),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _englishTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'English',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onSaveImage();
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void onSaveImage() {
    final englishText = _englishTextController.text;
    if (englishText.isEmpty) {
      return;
    }
  }

  void onCaptureImage() async {
    final imageFile = await _getImage();
    if (imageFile == null) {
      return;
    }

    final mediaQuery = MediaQuery.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          child: _buildImagePreview(
            File(imageFile.path),
          ),
        ),
      ),
    );
  }

  Future<XFile?> _getImage() async {
    final imageFile = await _imagePicker.pickImage(
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.rear,
      source: ImageSource.gallery,
    );

    return imageFile;
  }
}
