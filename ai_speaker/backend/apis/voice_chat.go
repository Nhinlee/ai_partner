package apis

import (
	"ai_speaker/golibs/tts"
	pb "ai_speaker/pb/chat"
	"context"
	"fmt"
	"io"
)

func (s *Server) VoiceChat(req *pb.VoiceChatRequest, svc pb.VoiceChatService_VoiceChatServer) error {
	fmt.Printf("Received: %v\n", req.Text)

	// NOTE: TESTING ONLY

	// Load test.mp3 file local to reponse to client
	// fileName := "ai_pcm16.raw"
	// audioData, err := os.ReadFile(fileName)
	// if err != nil {
	// 	return fmt.Errorf("VoiceChat: failed to read file: %v", err)
	// }

	// for i := 0; i < 10; i++ {
	// 	time.Sleep(1 * time.Second)

	// 	err := svc.Send(&pb.VoiceChatResponse{
	// 		Audio: audioData,
	// 		IsEnd: false,
	// 	})
	// 	if err != nil {
	// 		return fmt.Errorf("VoiceChat: failed to send response: %v", err)
	// 	}

	// 	// Add delay to simulate real-time conversation
	// 	time.Sleep(1 * time.Second)
	// }

	ctx := svc.Context()
	contentChan, err := s.ChatBot.GenerateRealtimeContent(ctx, req.Text)
	if err != nil {
		return fmt.Errorf("VoiceChat: failed to generate content: %v", err)
	}

	// Generate audio data from content channel
	audioChannel, err := s.generateAudioData(ctx, contentChan)
	if err != nil {
		return fmt.Errorf("VoiceChat: failed to generate audio data: %v", err)
	}

	// Send audio data to client
	for audioData := range audioChannel {
		fmt.Printf("Audio data len: %v\n", len(audioData))
		err := svc.Send(&pb.VoiceChatResponse{
			Audio: audioData,
			IsEnd: false,
		})
		if err != nil {
			return fmt.Errorf("VoiceChat: failed to send response: %v", err)
		}
	}

	return nil
}

func (s *Server) generateAudioData(ctx context.Context, contentChan <-chan string) (chan []byte, error) {
	audioDataChan := make(chan []byte)

	go func() {
		defer close(audioDataChan)

		for content := range contentChan {
			fmt.Printf("Content: %s\n", content)

			// Use TTS to convert text to speech
			audioResp, err := s.TTS.CreateSpeech(ctx, &tts.CreateSpeechRequest{
				Input:          content,
				ResponseFormat: "mp3", // TODO: Use enum
				Speed:          1.0,
			})
			if err != nil {
				fmt.Printf("failed to create speech: %v", err)
				return
			}

			audioData, err := readAudioData(audioResp)
			if err != nil {
				fmt.Printf("failed to read audio data: %v", err)
				return
			}

			audioDataChan <- audioData
		}
	}()

	return audioDataChan, nil
}

func readAudioData(audioResp io.ReadCloser) ([]byte, error) {
	const chunkSize = 1024
	audioData := make([]byte, 0)
	buf := make([]byte, chunkSize)
	for {
		n, err := audioResp.Read(buf)
		if n > 0 {
			audioData = append(audioData, buf[:n]...)
		}
		if err != nil {
			break
		}
	}

	return audioData, nil
}
