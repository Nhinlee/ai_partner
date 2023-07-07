import 'dart:io';

class LearningItemModel {
  final String englishWord;

  final String? vietnameseWord;

  final File file;

  LearningItemModel({
    required this.englishWord,
    required this.file,
    this.vietnameseWord,
  });
}
