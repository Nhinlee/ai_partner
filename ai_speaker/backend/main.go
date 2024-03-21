package main

import (
	"context"

	"ai_speaker/apis"
	"ai_speaker/configs"
	"ai_speaker/golibs/chat_bot/gemini"
	openai_tts "ai_speaker/golibs/tts/open_ai"

	openai "github.com/sashabaranov/go-openai"
)

func main() {
	// load secret
	secret, err := configs.NewSecret()
	if err != nil {
		panic(err)
	}

	// new Gemini AI model
	ctx := context.Background()
	gemini, err := gemini.NewGemini(ctx, secret.AI.GenaiAPIKey)
	if err != nil {
		panic(err)
	}

	// new Open AI client
	client := openai.NewClient(secret.AI.OpenAiTTSKey)
	tts := openai_tts.NewOpenAiTTS(client)

	server, err := apis.NewServer(gemini, tts)
	if err != nil {
		panic(err)
	}

	server.Start()
}
