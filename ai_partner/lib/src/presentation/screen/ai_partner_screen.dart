import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class AIPartnerScreen extends StatefulWidget {
  const AIPartnerScreen({Key? key}) : super(key: key);

  @override
  State<AIPartnerScreen> createState() => _AIPartnerScreenState();
}

class _AIPartnerScreenState extends State<AIPartnerScreen> {
  String aiResp = 'Waiting Response ...';
  final textController = TextEditingController();
  final openAIAPIKey = 'key';

  late OpenAI openAI;

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: openAIAPIKey,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 20),
          connectTimeout: const Duration(seconds: 20),
        ),
        isLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Partner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "Fill your topic here!"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(aiResp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getContent() {
    return 'Can y help me to create list of questions about "${textController.text}"?';
  }

  void chatComplete() async {
    final request = ChatCompleteText(messages: [
      Map.of(
        {
          "role": "user",
          "content": getContent(),
        },
      )
    ], maxToken: 200, model: ChatModel.chatGptTurbo0301Model);

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
    }
  }
}
