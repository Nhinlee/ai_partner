package configs

import (
	"os"

	"github.com/joho/godotenv"
)

type Secret struct {
	AI AISecret
}

type AISecret struct {
	// Gemini AI keys
	GenaiAPIKey string

	// OpenAI keys
	OpenAiTTSKey string
}

func NewSecret() (*Secret, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, err
	}

	return &Secret{
		AI: AISecret{
			GenaiAPIKey: os.Getenv("GENAI_API_KEY"),
			OpenAiTTSKey: os.Getenv("OPENAI_TTS_KEY"),
		},
	}, nil
}
