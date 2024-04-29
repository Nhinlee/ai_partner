package apis

import (
	"ai_speaker/golibs/tts"
	pb "ai_speaker/pb/chat"
	"fmt"
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

	var respMessage string
	for content := range contentChan {
		fmt.Printf("Content: %s\n", content)
		respMessage = content
		break
	}

	// Use TTS to convert text to speech
	audioResp, err := s.TTS.CreateSpeech(ctx, &tts.CreateSpeechRequest{
		Input:          respMessage,
		ResponseFormat: "mp3", // TODO: Use enum
		Speed:          1.0,
	})
	if err != nil {
		return fmt.Errorf("VoiceChat: failed to create speech: %v", err)
	}
	defer audioResp.Close()

	// Read audio data from TTS response
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

	fmt.Printf("Audio data length: %d\n", len(audioData))

	// Send audio data to client
	err = svc.Send(&pb.VoiceChatResponse{
		Audio: audioData,
		IsEnd: false,
	})
	if err != nil {
		return fmt.Errorf("VoiceChat: failed to send response: %v", err)
	}

	return nil
}
