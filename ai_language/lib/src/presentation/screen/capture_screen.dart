import 'dart:io';

import 'package:ai_language/entity.dart';
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

  // TODO: save these image & work into database
  final List<LearningItemModel> _learningItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Learning Language App'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onCaptureImage(),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    // Return GridView 2 columns with learning items
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _learningItems.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                _learningItems[index].file,
                width: double.infinity,
                height: 128,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(_learningItems[index].englishWord),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _learningItems.length,
      itemBuilder: (context, index) {
        final learningItem = _learningItems[index];
        return ListTile(
          leading: Image.file(
            learningItem.file,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
          title: Text(learningItem.englishWord),
          subtitle: Text(learningItem.vietnameseWord ?? ''),
        );
      },
    );
  }

  Widget _buildImagePreview(File imageFile) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'English',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onSaveImage(imageFile);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void onSaveImage(File imageFile) {
    final englishText = _englishTextController.text;
    if (englishText.isEmpty) {
      return;
    }

    setState(() {
      _learningItems.add(
        LearningItemModel(englishWord: englishText, file: imageFile),
      );
    });

    _englishTextController.clear();
  }

  void onCaptureImage() async {
    final imageFile = await _getImage();
    if (imageFile == null) {
      return;
    }

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
