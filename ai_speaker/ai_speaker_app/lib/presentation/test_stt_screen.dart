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

  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;
  bool _isRecording = false;

  late IOWebSocketChannel channel;

  static const serverUrl =
      'wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-GB';
  static const apiKey =
      'YOUR API KEY'; // NOTE: Replace with your Deepgram API key (just for testing)

  final audioPlayer = AudioPlayer();

  final _messageController = TextEditingController();

  final _soundStreamingPlayerKey = GlobalKey<VoiceStreamPlayerWidgetState>();

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
    debugPrint('>>> init stream');
    channel = IOWebSocketChannel.connect(Uri.parse(serverUrl),
        headers: {'Authorization': 'Token $apiKey'});

    channel.stream.listen((event) async {
      debugPrint('>>> event from stream: $event');
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

    await _recorder.initialize();
  }

  void _startRecord() async {
    resetText();
    await _initStream();

    await _recorder.start();

    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecord() async {
    _disposeRecorder();
    setState(() {
      _isRecording = false;
    });
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
              onPressed: !_isRecording
                  ? () {
                      updateText('');
                      _startRecord();
                    }
                  : null,
              child: const Text('Start STT'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
            if (_isRecording)
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _soundStreamingPlayerKey?.currentState?.startPlayer();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Get Gemini AI response'),
            ),
            VoiceStreamPlayerWidget(
              key: _soundStreamingPlayerKey,
              voiceClient: widget.voiceClient,
              messageController: _messageController,
            ),
          ],
        ),
      ),
    );
  }

  void updateText(newText) {
    setState(() {
      textFromSpeaker += newText;
    });
    _messageController.text = textFromSpeaker;
  }

  void resetText() {
    _messageController.clear();
    setState(() {
      textFromSpeaker = '';
    });
  }

  Future<void> _disposeRecorder() async {
    await _recorderStatus.cancel();
    await _audioStream.cancel();
    await channel.sink.close();
  }

  @override
  void dispose() {
    _disposeRecorder();
    super.dispose();
  }
}
