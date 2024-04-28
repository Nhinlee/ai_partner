import 'dart:async';
import 'dart:convert';

import 'package:ai_speaker_app/presentation/presentation.dart';
import 'package:ai_speaker_app/protobuf/generated/chat/voice.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';

class TestSTTScreen extends StatefulWidget {
  const TestSTTScreen({
    super.key,
    required this.voiceClient,
  });

  final VoiceChatServiceClient voiceClient;

  @override
  State<TestSTTScreen> createState() => _TestSTTScreenState();
}

class _TestSTTScreenState extends State<TestSTTScreen> {
  String textFromSpeaker = '';
  final RecorderStream _recorder = RecorderStream();
  final _playerStream = PlayerStream();

  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;

  late IOWebSocketChannel channel;

  static const serverUrl =
      'wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-GB';
  static const apiKey =
      'YOUR API KEY'; // NOTE: Replace with your Deepgram API key (just for testing)

  final audioPlayer = AudioPlayer();
  bool isStartedFlutterSound = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {
    await Permission.microphone.request();
    setState(() {});
  }

  Future<void> _initStream() async {
    channel = IOWebSocketChannel.connect(Uri.parse(serverUrl),
        headers: {'Authorization': 'Token $apiKey'});

    channel.stream.listen((event) async {
      final parsedJson = jsonDecode(event);
      final transcript = parsedJson['channel']['alternatives'][0]['transcript'];

      debugPrint('>>> transcript from stream: $transcript');
      updateText(transcript);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.sink.add(data);
    });

    _recorderStatus = _recorder.status.listen((status) {
      if (mounted) {
        setState(() {});
      }
    });

    await Future.wait([
      _recorder.initialize(),
    ]);
  }

  void _startRecord() async {
    resetText();
    await _initStream();

    await _recorder.start();

    setState(() {});
  }

  void _stopRecord() async {
    await _recorder.stop();

    setState(() {});
  }

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
              onPressed: () {
                updateText('');
                _startRecord();
              },
              child: const Text('Start STT'),
            ),
            OutlinedButton(
              onPressed: () {
                _stopRecord();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Stop STT'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  isStartedFlutterSound = !isStartedFlutterSound;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Play voice message with just flutter sound'),
            ),
            if (isStartedFlutterSound)
              VoiceStreamPlayerWidget(
                audioStream: widget.voiceClient
                    .voiceChat(
                      VoiceChatRequest(
                        text:
                            "Hello, this is a test message from Flutter app. Ahihi!",
                      ),
                    )
                    .map(
                      (event) => event.audio,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  void updateText(newText) {
    setState(() {
      textFromSpeaker = textFromSpeaker + ' ' + newText;
    });
  }

  void resetText() {
    setState(() {
      textFromSpeaker = '';
    });
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStream.cancel();
    channel.sink.close();

    super.dispose();
  }
}
