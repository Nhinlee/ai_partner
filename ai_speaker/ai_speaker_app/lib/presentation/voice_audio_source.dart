import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class VoiceAudioSource extends StreamAudioSource {
  final Stream<List<int>> stream;
  final List<int> buffer = [];
  VoiceAudioSource(this.stream) {
    stream.listen((data) {
      debugPrint('>>> data: $data');
      _streamController.add(data);
      buffer.addAll(data);
    });
  }

  int index = 0;

  StreamController<List<int>> _streamController =
      StreamController<List<int>>.broadcast();
  StreamController<List<int>> get streamController => _streamController;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= index;
    end = buffer.length;
    index = end;

    debugPrint('>>> start: $start, end: $end, index: $index');

    return StreamAudioResponse(
      sourceLength: null,
      contentLength: end,
      offset: start,
      stream: streamController.stream.asBroadcastStream(),
      contentType: 'audio/mpeg',
    );
  }
}
