package gemini

import (
	"context"

	"github.com/google/generative-ai-go/genai"
	"github.com/pkg/errors"
	"google.golang.org/api/option"
)

type Gemini struct {
	model *genai.GenerativeModel
}

func NewGemini(ctx context.Context, apiKey string) (*Gemini, error) {
	client, err := genai.NewClient(ctx, option.WithAPIKey(apiKey))
	if err != nil {
		return nil, errors.Errorf("failed to create new client: %v", err)
	}

	model := client.GenerativeModel("gemini-pro")

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

	var text string
	for _, candidate := range resp.Candidates {
		text = getCombinedText(candidate.Content)
	}

	return text, nil
}

func getCombinedText(content *genai.Content) string {
	var text string
	for _, part := range content.Parts {
		if textContent, ok := part.(genai.Text); ok {
			text += string(textContent)
		}
	}
	return text
}
