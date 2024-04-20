package apis

import (
	"fmt"
	"net"
	"os"

	chatbot "ai_speaker/golibs/chat_bot"
	"ai_speaker/golibs/tts"
	pb "ai_speaker/pb/chat"

	"github.com/gin-gonic/gin"
	"google.golang.org/grpc"
)

type Server struct {
	router *gin.Engine

	pb.UnimplementedVoiceChatServiceServer

	// Large Language Model chatbot
	ChatBot chatbot.ChatBot

	// Text-to-Speech
	TTS tts.TTS
}

func NewServer(chatBot chatbot.ChatBot, tts tts.TTS) (*Server, error) {
	server := &Server{
		ChatBot: chatBot,
		TTS:     tts,
	}

	// Setup REST API
	// server.SetupREST()

	// Setup gRPC API
	err := server.SetupGRPC()
	if err != nil {
		return nil, err
	}

	return server, nil
}

func (s *Server) SetupGRPC() error {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", os.Getenv("GRPC_PORT")))
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return err
	}

	var opts []grpc.ServerOption
	grpcServer := grpc.NewServer(opts...)

	// Register the service with the server
	pb.RegisterVoiceChatServiceServer(grpcServer, s)

	fmt.Printf("Server started on port %s\n", os.Getenv("GRPC_PORT"))
	err = grpcServer.Serve(lis)
	if err != nil {
		fmt.Printf("failed to serve: %v", err)
		return err
	}

	return nil
}

func (s *Server) SetupREST() {
	router := gin.Default()

	router.GET("/ping", s.Ping)
	router.POST("/v1/chat/text/generate", s.GenerateContent)
	router.POST("/v1/chat/text/realtime", s.GenerateRealtimeContent)

	s.router = router

	s.Start()
}

// Run http server on address
func (server *Server) Start() error {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Use a default port if not provided by Heroku
	}

	return server.router.Run(fmt.Sprintf(":%s", port))
}
