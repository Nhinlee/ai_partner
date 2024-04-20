import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class VoiceAudioSource extends StreamAudioSource {
  final Stream<List<int>> stream;
  final List<int> buffer = [];
  VoiceAudioSource(this.stream) {
    stream.listen((data) {
      debugPrint('>>> data: $data');
      buffer.addAll(data);
    });
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= buffer.length;

    return StreamAudioResponse(
      sourceLength: buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(buffer.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
