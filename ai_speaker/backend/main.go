package main

import (
	"ai_speaker/golibs/ai/gemini"
	"context"
)

func main() {
	// new Gemini AI model
	ctx := context.Background()
	gemini, err := gemini.NewGemini(ctx)
	if err != nil {
		panic(err)
	}

	// generate text
	text, err := gemini.GenerateContent(ctx, "Are y Gemini pro?")
	if err != nil {
		panic(err)
	}

	// print generated text
	println(text)
}
