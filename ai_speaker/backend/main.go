package main

import (
	"ai_speaker/apis"
	"ai_speaker/configs"
	"ai_speaker/golibs/ai/gemini"
	"context"
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

	server, err := apis.NewServer(gemini)
	if err != nil {
		panic(err)
	}

	server.Start()
}
