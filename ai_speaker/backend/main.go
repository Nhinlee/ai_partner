package main

import (
	"ai_speaker/configs"
	"ai_speaker/golibs/ai/gemini"
	"context"
	"fmt"
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

	// generate text
	text, err := gemini.GenerateContent(ctx, "Are y Gemini pro?")
	if err != nil {
		panic(err)
	}

	// print generated text
	fmt.Printf("Generated text: %s\n", text)
}
