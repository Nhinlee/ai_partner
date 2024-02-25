package gemini

import (
	"context"
	"os"

	"github.com/google/generative-ai-go/genai"
	"github.com/pkg/errors"
	"google.golang.org/api/option"
)

type Gemini struct {
	model *genai.GenerativeModel
}

func NewGemini(ctx context.Context) (*Gemini, error) {
	apiKey := os.Getenv("GENAI_API_KEY")
	println(apiKey)
	client, err := genai.NewClient(ctx, option.WithAPIKey(apiKey))
	if err != nil {
		return nil, errors.Errorf("failed to create new client: %v", err)
	}
	defer client.Close()

	model := client.GenerativeModel("gemini-pro-vision")

	return &Gemini{
		model: model,
	}, nil
}

func (g *Gemini) GenerateContent(ctx context.Context, prompt string) (string, error) {
	if g.model == nil {
		return "", errors.Errorf("model is not initialized")
	}

	resp, err := g.model.GenerateContent(ctx, genai.Text(prompt))
	if err != nil {
		return "", errors.Errorf("failed to generate content: %v", err)
	}

	return resp.PromptFeedback.BlockReason.String(), nil
}
