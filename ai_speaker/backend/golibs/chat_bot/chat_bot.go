package chatbot

import "context"

type ChatBot interface {
	GenerateContent(ctx context.Context, prompt string) (string, error)
	GenerateRealtimeContent(ctx context.Context, prompt string, ops RealtimeContentOptions) (chan string, error)
}

type RealtimeContentOptions struct {
	MaxSentencesPerMessage int // Max number of sentences per message in channel
}
