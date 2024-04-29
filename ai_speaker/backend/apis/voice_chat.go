package apis

import (
	pb "ai_speaker/pb/chat"
	"fmt"
	"os"
	"time"
)

func (s *Server) VoiceChat(req *pb.VoiceChatRequest, svc pb.VoiceChatService_VoiceChatServer) error {
	fmt.Printf("Received: %v\n", req.Text)

	// Load test.mp3 file local to reponse to client
	fileName := "ai_pcm16.raw"
	audioData, err := os.ReadFile(fileName)
	if err != nil {
		return fmt.Errorf("VoiceChat: failed to read file: %v", err)
	}

	for i := 0; i < 10; i++ {
		time.Sleep(1 * time.Second)

		err := svc.Send(&pb.VoiceChatResponse{
			Audio: audioData,
			IsEnd: false,
		})
		if err != nil {
			return fmt.Errorf("VoiceChat: failed to send response: %v", err)
		}

		// Add delay to simulate real-time conversation
		time.Sleep(1 * time.Second)
	}

	return nil
}
