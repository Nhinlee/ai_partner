package configs

import (
	"os"

	"github.com/joho/godotenv"
)

type Secret struct {
	AI AISecret
}

type AISecret struct {
	GenaiAPIKey string
}

func NewSecret() (*Secret, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, err
	}

	return &Secret{
		AI: AISecret{
			GenaiAPIKey: os.Getenv("GENAI_API_KEY"),
		},
	}, nil
}
