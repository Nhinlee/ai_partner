package openai

import (
	"ai_speaker/golibs/tts"
	"context"
	"errors"
	"io"

	"github.com/sashabaranov/go-openai"
)

type OpenAiTTS struct {
	Client *openai.Client
}

func NewOpenAiTTS(client *openai.Client) *OpenAiTTS {
	return &OpenAiTTS{
		Client: client,
	}
}

// TODO: Add unit tests
func (tts *OpenAiTTS) CreateSpeech(ctx context.Context, req *tts.CreateSpeechRequest) (io.ReadCloser, error) {
	if req == nil {
		return nil, errors.New("request is nil")
	}

	if req.Input == "" {
		return nil, errors.New("input is empty")
	}

	if req.Speed <= 0 {
		return nil, errors.New("speed is invalid")
	}

	return tts.Client.CreateSpeech(ctx, openai.CreateSpeechRequest{
		Input:          req.Input,
		ResponseFormat: openai.SpeechResponseFormatMp3, // TODO: use opus format to optimize bandwidth
		Speed:          float64(req.Speed),
		Voice:          openai.VoiceFable,
		Model:          openai.TTSModel1,
	})
}
