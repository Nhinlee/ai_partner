package chatbot

import "context"

type ChatBot interface {
	GenerateContent(ctx context.Context, prompt string) (string, error)
	GenerateRealtimeContent(ctx context.Context, prompt string) (chan string, error)
}
