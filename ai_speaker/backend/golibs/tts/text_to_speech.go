package tts

import (
	"context"
	"io"
)

type TTS interface {
	CreateSpeech(ctx context.Context, req *CreateSpeechRequest) (io.ReadCloser, error)
}

type CreateSpeechRequest struct {
	Input          string  `json:"input"`
	ResponseFormat string  `json:"response_format"`
	Speed          float32 `json:"speed"`
}
