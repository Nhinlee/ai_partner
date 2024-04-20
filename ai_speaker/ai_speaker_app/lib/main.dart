import 'package:ai_speaker_app/presentation/presentation.dart';
import 'package:ai_speaker_app/protobuf/generated/chat/voice.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

void main() {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  // TODO: this is test code, will refactor to follow IOC & DI pattern later
  final voiceClient = VoiceChatServiceClient(channel);

  runApp(
    MyApp(
      voiceClient: voiceClient,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.voiceClient,
  });

  final VoiceChatServiceClient voiceClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestSTTScreen(
        voiceClient: voiceClient,
      ),
    );
  }
}
