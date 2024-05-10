package apis

import (
	"fmt"
	"net"
	"os"
	"strings"

	chatbot "ai_speaker/golibs/chat_bot"
	"ai_speaker/golibs/tts"
	pb "ai_speaker/pb/chat"

	"github.com/gin-gonic/gin"
	"google.golang.org/grpc"
)

type APIArch string

const (
	REST APIArch = "rest"
	GRPC APIArch = "grpc"
)

func ToAPIArch(str string) APIArch {
	str = strings.ToLower(str) // Normalize to lowercase

	switch str {
	case "rest":
		return REST
	case "grpc":
		return GRPC
	default:
		fmt.Printf("Unknown API architecture: %s\n", str)
		fmt.Printf("Defaulting to REST API\n")
		return REST
	}
}

type Server struct {
	router *gin.Engine

	pb.UnimplementedVoiceChatServiceServer

	// Large Language Model chatbot
	ChatBot chatbot.ChatBot

	// Text-to-Speech
	TTS tts.TTS
}

func NewServer(api APIArch, chatBot chatbot.ChatBot, tts tts.TTS) (*Server, error) {
	server := &Server{
		ChatBot: chatBot,
		TTS:     tts,
	}

	if api == REST {
		server.SetupREST()
	} else if api == GRPC {
		err := server.SetupGRPC()
		if err != nil {
			return nil, err
		}
	}

	return server, nil
}

func (s *Server) SetupGRPC() error {
	// Create a listener on TCP port
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", os.Getenv("GRPC_PORT")))
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return err
	}

	// Create a gRPC server object
	var opts []grpc.ServerOption
	grpcServer := grpc.NewServer(opts...)

	// Register the service with the server
	pb.RegisterVoiceChatServiceServer(grpcServer, s)

	// Serve the server
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
