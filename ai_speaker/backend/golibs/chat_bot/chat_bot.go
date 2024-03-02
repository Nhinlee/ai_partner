package chatbot

import "context"

type ChatBot interface {
	GenerateContent(ctx context.Context, prompt string) (string, error)
}
