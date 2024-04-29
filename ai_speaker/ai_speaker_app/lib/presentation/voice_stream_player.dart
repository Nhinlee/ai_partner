import 'dart:collection';
import 'dart:typed_data';

import 'package:ai_speaker_app/protobuf/generated/chat/voice.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class VoiceStreamPlayerWidget extends StatefulWidget {
  const VoiceStreamPlayerWidget({
    super.key,
    required this.voiceClient,
    required this.messageController,
  });

  final VoiceChatServiceClient voiceClient;
  final TextEditingController messageController;

  @override
  State<VoiceStreamPlayerWidget> createState() =>
      VoiceStreamPlayerWidgetState();
}

class VoiceStreamPlayerWidgetState extends State<VoiceStreamPlayerWidget> {
  final _player = FlutterSoundPlayer();
  bool _isPlayerInitialized = false;
  bool _isPlayerStarted = false;

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
    });
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  void startPlayer() async {
    if (_isPlayerStarted) {
      return;
    }
    _isPlayerStarted = true;
    await _player.stopPlayer();

    assert(_isPlayerInitialized && _player.isStopped);
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});

    audioStream:
    widget.voiceClient
        .voiceChat(
          VoiceChatRequest(
            text: widget.messageController.text,
          ),
        )
        .map(
          (event) => event.audio,
        )
        .listen(
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
    _player.stopPlayer();
    _isPlayerStarted = false;
    setState(() {});
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
    if (!_isPlayerInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_player.isStopped) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'AI is listening',
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
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
