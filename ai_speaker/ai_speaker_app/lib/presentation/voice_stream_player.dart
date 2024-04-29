import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class VoiceStreamPlayerWidget extends StatefulWidget {
  const VoiceStreamPlayerWidget({
    super.key,
    required this.audioStream,
  });

  final Stream<List<int>> audioStream;

  @override
  State<VoiceStreamPlayerWidget> createState() =>
      _VoiceStreamPlayerWidgetState();
}

class _VoiceStreamPlayerWidgetState extends State<VoiceStreamPlayerWidget> {
  final _player = FlutterSoundPlayer();
  bool _isPlayerInitialized = false;

  static const blockSize = 2048;
  static const int tSampleRate = 24000;
  bool isFeeding = false;
  final _audioQueue = Queue<Uint8List>();

  @override
  void initState() {
    super.initState();

    _player.openPlayer().then((value) {
      setState(() {
        _isPlayerInitialized = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        startPlayer();
      });
    });
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  void startPlayer() async {
    assert(_isPlayerInitialized && _player.isStopped);
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});

    widget.audioStream.listen(
      (data) async {
        _audioQueue.add(Uint8List.fromList(data));
        if (!isFeeding) {
          isFeeding = true;
          startFeeding();
        }
      },
    );
  }

  void startFeeding() async {
    while (_audioQueue.isNotEmpty) {
      var data = _audioQueue.removeFirst();
      await feedHim(data);
    }
    isFeeding = false;
  }

  Future<void> feedHim(Uint8List buffer) async {
    debugPrint('>>> feedHim - buffer: $buffer');
    var lnData = 0;
    var totalLength = buffer.length;
    while (totalLength > 0 && !_player.isStopped) {
      var bsize = totalLength > blockSize ? blockSize : totalLength;
      await _player.feedFromStream(
        buffer.sublist(lnData, lnData + bsize),
      ); // await !!!!
      lnData += bsize;
      totalLength -= bsize;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Implement audio player UI here
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Voice stream playing ...',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
